$DatabaseClass = new-psclass Database `
{
    note -private Config
  
    constructor {
        param ($config)
        $private.Config = $config
    }

    method CompareSchema {
        param ([string] $prevSchema, [string] $nextSchema, [string] $output, [string] $databaseName)

        & $private.Config.vsdb_tool /a:deploy /dd:- /dsp:sql /model:$prevSchema /targetmodelfile:$nextSchema /DeploymentScriptFile:$output /p:TargetDatabase=$databaseName /p:DeployDatabaseProperties=False /p:GenerateDeployStateChecks=False | out-null
    }
        
    method CompareDatabases {
        param([string] $sourceDatabaseName, [string] $destinationDatabaseName, [string] $output)
            
        $sourceConnectionString = $private.Config.connectionString + "Database=" + $sourceDatabaseName
        $destinationConnectionString = $private.Config.connectionString + "Database=" + $destinationDatabaseName
            
        $out = & $private.Config.ocdb_tool CN1=$sourceConnectionString CN2=$destinationConnectionString F=$output | Out-Default
        
        if($LastExitCode -ne 0)
        {
            throw "sqlcmd: script execution failed"
        }
        
        #$out = [string]::join("", $out)
            
        #if($out -ne "Reading first database...Reading second database...Comparing databases schemas...Generating SQL file...")
        #{
        #    throw $out
        #}
                       
        $infile = [IO.File]::ReadAllText($output) `
            -replace '(?s).*?USE \[.[^\]]*\]\r\nGO\r\n(.*)$',"`$1"
            #-replace '(/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+/)|(//.*)', "$1" `
            
        set-content -Value $infile $output
    }
        
    method ScriptDatabase {
        param([string] $sourceDatabaseName, [string] $destinationDatabaseName, [string] $databaseName, [string] $output)
            
        $this.CompareDatabases($sourceDatabaseName, $destinationDatabaseName, $output)

        $infile = "CREATE DATABASE [$databaseName]`r`nGO`r`nUSE [$databaseName]`r`nGO`r`n" + [IO.File]::ReadAllText($output)

        set-content -Value $infile $output
    }
        
    method DropDatabase {
        param([string] $databaseName)
            
        $query = "IF (DB_ID(N'$databaseName') IS NOT NULL) 
            BEGIN
                ALTER DATABASE [$databaseName]
                SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
                DROP DATABASE [$databaseName];
            END"
                            
        & $private.Config.sqlcmd_tool -S $private.Config.serverName -Q $query | Out-Default
            
        if($LastExitCode -ne 0)
        {
            throw "sqlcmd: script execution failed"
        }
    }
        
    method CreateEmptyDatabase {
        param([string] $databaseName)
            
        $query = "CREATE DATABASE [$databaseName]`r`nGO"
                            
        $out = & $private.Config.sqlcmd_tool -S $private.Config.serverName -Q $query | Out-Default
            
        if($LastExitCode -ne 0)
        {
            throw "sqlcmd: script execution failed"
        }
    }

    method Exists {
        param([string] $databaseName)
            
        $query = "
            SET NOCOUNT ON
            GO 
            SELECT DB_ID(N'$databaseName')"
                            
        $out = & $private.Config.sqlcmd_tool -S $private.Config.serverName -Q $query

        if($LastExitCode -ne 0)
        {
            throw "sqlcmd: script execution failed"
        }
            
        (($out | select -last 1)  -replace '\s+', '') -ne "NULL"
    }
        
    method CreateScript {
        param ([string] $schema, [string] $output, [string] $databaseName)

        & $private.Config.vsdb_tool /a:deploy /dd:- /dsp:sql /model:$schema /DeploymentScriptFile:$output /p:TargetDatabase=$databaseName /p:DeployDatabaseProperties=False /p:GenerateDeployStateChecks=False | Out-Default

        if($LastExitCode -ne 0)
        {
            throw "vsdb: script creation failed"
        }
            
        $infile = [IO.File]::ReadAllText((join-path $pwd $output)) `
            -replace '(?s).*?(CREATE DATABASE \[\$\(DatabaseName\)\].*)$',"`$1" `
            -replace '\[\$\(DatabaseName\)\]', ("[" + $databaseName + "]")
            
        set-content -Value $infile $output
    }
        
    method DeployPackage {
        param ([string] $databaseName, [string] $packagePath)

        & $private.Config.dbadvance_tool -c $private.Config.connectionString $databaseName $packagePath | Out-Default

        if($LastExitCode -ne 0)
        {
            throw "dbadvance: script creation failed"
        }
    }
        
    method DeployPackageToVersion {
        param ([string] $databaseName, [string] $packagePath, [int32] $version)

        $versionName = "{0:D4}" -f $version
            
        & $private.Config.dbadvance_tool -cv $private.Config.connectionString $databaseName $packagePath $versionName | Out-Default

        if($LastExitCode -ne 0)
        {
            throw "dbadvance: script creation failed"
        }
    }
        
    method RollbackPackageToVersion {
        param ([string] $databaseName, [string] $packagePath, [int32] $version)
            
        $versionName = "{0:D4}" -f $version

        & $private.Config.dbadvance_tool -rv $private.Config.connectionString $databaseName $packagePath $versionName | Out-Default

        if($LastExitCode -ne 0)
        {
            throw "dbadvance: script creation failed"
        }
    }

    method GenerateDropScript {
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
                
    method DeploySchema {
        param ([string] $schema, [string] $databaseName)
            
        $connectionString = $private.Config.connectionString
            
        & $private.Config.vsdb_tool /a:deploy /dd:+ /model:$schema /p:TargetDatabase=$databaseName /cs:$connectionString /p:AlwaysCreateNewDatabase=True | Out-Default

        if($LastExitCode -ne 0)
        {
            throw "vsdb: script creation failed"
        }
    }
        
    method Execute {
        param ([string] $script, [string] $databaseName)
            
        & $private.Config.sqlcmd_tool -S $private.Config.serverName -d $databaseName -i $script | Out-Default

        if($LastExitCode -ne 0)
        {
            throw "sqlcmd: script execution failed"
        }
    }
        
    method CompareTables {
        param ([string] $sourceDatabaseName, [string] $destinationDatabaseName, [string[]] $tables, [ScriptBlock] $nameProvider)
            
        foreach($table in $tables)
        {
            $this.CompareTable($sourceDatabaseName, $destinationDatabaseName, $table, (& $nameProvider $table))
        }
    }
        
    method CompareTable {
        param ([string] $sourceDatabaseName, [string] $destinationDatabaseName, [string] $table, [string] $output)
        
        # source and destination are deliberately swapped due to tablediff behaviour
        & $private.Config.tablediff_tool -sourceserver $private.Config.serverName -sourcedatabase $destinationDatabaseName -sourcetable $table -destinationserver $private.Config.serverName -destinationdatabase $sourceDatabaseName -destinationtable $table -f $output -strict | Out-Default
        
        if($LastExitCode -ne 0)
        {
            throw "tablediff: table comparison failed"
        }
    }
}