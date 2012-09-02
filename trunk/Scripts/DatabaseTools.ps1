function create-database-tool
{
    param($config)
    
    New-Module {
        param($config)

        function CompareSchema
        {
            param ([string] $prevSchema, [string] $nextSchema, [string] $output, [string] $databaseName)

            & $config.vsdb_tool /a:deploy /dd:- /dsp:sql /model:$prevSchema /targetmodelfile:$nextSchema /DeploymentScriptFile:$output /p:TargetDatabase=$databaseName /p:DeployDatabaseProperties=False /p:GenerateDeployStateChecks=False | out-null
        }
        
        function CompareDatabases
        {
            param([string] $sourceDatabaseName, [string] $destinationDatabaseName, [string] $output)
            
            $sourceConnectionString = $config.connectionString + "Database=" + $sourceDatabaseName
            $destinationConnectionString = $config.connectionString + "Database=" + $destinationDatabaseName
            
            $out = & $config.ocdb_tool CN1=$sourceConnectionString CN2=$destinationConnectionString F=$output
            $out = [string]::join("", $out)
            
            if($out -ne "Reading first database...Reading second database...Comparing databases schemas...Generating SQL file...")
            {
                throw $out
            }
                       
            $infile = [IO.File]::ReadAllText($output) `
                -replace '(/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+/)|(//.*)', "$1" `
                -replace '(?s).*?USE \[.[^\]]*\]\r\nGO\r\n(.*)$',"`$1"
            
            set-content -Value $infile $output
        }
        
        function ScriptDatabase
        {
            param([string] $sourceDatabaseName, [string] $destinationDatabaseName, [string] $databaseName, [string] $output)
            
            CompareDatabases $sourceDatabaseName $destinationDatabaseName $output

            $infile = "CREATE DATABASE [$databaseName]`r`nGO`r`nUSE [$databaseName]`r`n" + [IO.File]::ReadAllText($output)

            set-content -Value $infile $output
        }
        
        function DropDatabase
        {
            param([string] $databaseName)
            
            $query = "IF (DB_ID(N'$databaseName') IS NOT NULL) 
                BEGIN
                    ALTER DATABASE [$databaseName]
                    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
                    DROP DATABASE [$databaseName];
                END"
                            
            $out = & $config.sqlcmd_tool -S $config.serverName -Q $query
            
            if($out -ne $null)
            {
                if(!$out.Contains("Nonqualified transactions are being rolled back"))
                {
                    throw $out
                }
            }
        }
        
        function CreateEmptyDatabase
        {
            param([string] $databaseName)
            
            $query = "CREATE DATABASE [$databaseName]`r`nGO"
                            
            $out = & $config.sqlcmd_tool -S $config.serverName -Q $query
            
            (($out | select -last 1)  -replace '\s+', '') -ne "NULL"
        }

        function Exists
        {
            param([string] $databaseName)
            
            $query = "
                SET NOCOUNT ON
                GO 
                SELECT DB_ID(N'$databaseName')"
                            
            $out = & $config.sqlcmd_tool -S $config.serverName -Q $query
            
            (($out | select -last 1)  -replace '\s+', '') -ne "NULL"
        }
        
        function CreateScript
        {
            param ([string] $schema, [string] $output, [string] $databaseName)

            & $config.vsdb_tool /a:deploy /dd:- /dsp:sql /model:$schema /DeploymentScriptFile:$output /p:TargetDatabase=$databaseName /p:DeployDatabaseProperties=False /p:GenerateDeployStateChecks=False | out-null
            
            $infile = [IO.File]::ReadAllText((join-path $pwd $output)) `
                -replace '(?s).*?(CREATE DATABASE \[\$\(DatabaseName\)\].*)$',"`$1" `
                -replace '\[\$\(DatabaseName\)\]', ("[" + $databaseName + "]")
            
            set-content -Value $infile $output
        }
        
        function DeployPackage
        {
            param ([string] $databaseName, [string] $packagePath)

            & $config.dbadvance_tool -c $config.connectionString $databaseName $packagePath
        }
        
        function DeployPackageToVersion
        {
            param ([string] $databaseName, [string] $packagePath, [int32] $version)
            
            & $config.dbadvance_tool -cv $config.connectionString $databaseName $packagePath $version
        }
        
        function RollbackPackageToVersion
        {
            param ([string] $databaseName, [string] $packagePath, [int32] $version)
            
            & $config.dbadvance_tool -rv $config.connectionString $databaseName $packagePath $version
        }

        function GenerateDropScript
        {
            param ([string] $databaseName, [string] $output)

            $query = "
                    USE [master]
                    GO
                    
                    ALTER DATABASE [$databaseName]
                    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
                    GO
                    
                    DROP DATABASE [$databaseName];"
                
            New-Item $output -type file -force -value $query | out-null
        }
                
        function DeploySchema
        {
            param ([string] $schema, [string] $databaseName)
            
            $connectionString = $config.connectionString
            
            & $config.vsdb_tool /a:deploy /dd:+ /model:$schema /p:TargetDatabase=$databaseName /cs:$connectionString /p:AlwaysCreateNewDatabase=True | out-null
        }
        
        function Execute
        {
            param ([string] $script, [string] $databaseName)
            
            & $config.sqlcmd_tool -S $config.serverName -d $databaseName -i $script | out-null
        }
        
        function CompareTables
        {
            param ([string] $sourceDatabaseName, [string] $destinationDatabaseName, [string[]] $tables, [ScriptBlock] $nameProvider)
            
            foreach($table in $tables)
            {
                CompareTable $sourceDatabaseName $destinationDatabaseName $table (& $nameProvider $table)
            }
        }
        
        function CompareTable
        {
            param ([string] $sourceDatabaseName, [string] $destinationDatabaseName, [string] $table, [string] $output)
        
            # source and destination are deliberately swapped due to tablediff behaviour
            $out = & $config.tablefiff_tool -sourceserver $config.serverName -sourcedatabase $destinationDatabaseName -sourcetable $table -destinationserver $config.serverName -destinationdatabase $sourceDatabaseName -destinationtable $table -f $output -strict
            $out = [string]::join([Environment]::NewLine, $out)
            
            if($out.Contains("does not exist, or the user specified doesn't have permissions to access it"))
            {
                throw $out
            }
        }
        
        Export-ModuleMember -Variable * -Function *                
    } -ArgumentList $config -asCustomObject
}