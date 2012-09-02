function new-slice-package
{
    param($config, $packagePath, $tupleFactory, $fileSystem)
    
    New-Module {
        param($config, $packagePath, $tupleFactory, $fileSystem)

        $sliceStaticFolder = join-path $packagePath "StaticData"
        
        function get-static-data-indexfile()
        {
           $staticDataPath = join-path $packagePath "StaticData"
           join-path $staticDataPath "index.xml"
        }
        
        function get-static-data-tablefile()
        {
           param ([string] $table)
           
           $staticDataPath = join-path $packagePath "StaticData"
           $tableFile = (join-path $staticDataPath ($table + ".sql"))
           
           if (!(test-path $tableFile))
           {
                throw ("Static data file for table '" + $table + "' is not found.")
           }
           
           $tableFile
        }

        function GetStaticDataScripts
        {            
            $indexFile = get-static-data-indexfile $packagePath
            
            $tableNames = @()
            
            if (test-path $indexFile)
            {
                [xml]$index = get-content $indexFile
                
                foreach($table in $index.tables.table)
                {
                    $tableName = $table.name
                    $filePath = get-static-data-tablefile($table.name)
                    $tableNames += @($tupleFactory.Create(@("Name", $tableName, "Path", $filePath)))
                }
            }
            
            ,$tableNames
        }
      
        function GetSchemaPath
        {
            join-path $packagePath $config.schemaName
        }
        
        function ContainsStaticData
        {
            param ([string] $tableName)
            
            (& GetStaticDataScripts) | %{ $_.Name } | -contains $tableName
        }
        
        function GetUniqueDatabaseName
        {
            $databaseName + $delta.FromVersion	
        }
        
        function GetDatabaseName
        {
            $databaseName
        }
        
        function CopyToRoot
        {
            param([string] $releasePath)
            
            copy-item $releasePath $packagePath
        }
        
        function CopyToStaticData
        {
            param($files)
            
            $files | % { copy-item $_.FullName $sliceStaticFolder }
        }
        
        function Init
        { 
            $fileSystem.Recreate($packagePath)
    	   
            new-item $sliceStaticFolder -type directory | out-null
        }
        
        Export-ModuleMember -Variable * -Function *                
    } -ArgumentList @($config, $packagePath, $tupleFactory, $fileSystem) -asCustomObject
}