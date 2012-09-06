function new-material-source
{
    param($database, $msbuild)
     
    New-Module {
        param($database, $msbuild)

        $schemaName = "AdventureWorks2008.dbschema"   

        function GetTransitionVersions
        {
            param ([string] $solutionPath)
            
            [xml] $xml = get-content (join-path $solutionPath "slices.xml")
            
            $xml.versions.version | 
                %{ [int32]::parse($_) }
        }
        
        function GetMigrations
        {
            param ([string] $solutionPath)
            
            , (list-migrations $solutionPath |
                %{ $_.Name } |
                %{ 
                    $data = $_.replace(".sql", "").split("-")
                    
                    $fromVersion = [int32]::parse($data[0])
                    $toVersion = [int32]::parse($data[1])
                    
                    ,@($fromVersion, $toVersion)
                } |
                ?{ $_[0] -le $_[1] })
        }
           
        function GetMigrationPath
        {
            param ([string] $solutionPath, [int32] $from, [int32] $to)
            
            $migrationsPath = join-path $solutionPath "AdventureWorks2008\Scripts\Migrations"
                    
            join-path $migrationsPath ($from.ToString() + "-" + $to.ToString() + ".sql")
        }
        
        function Build
        {
            param ([string] $solutionPath, [string] $buildPath)
            
            $msbuild.Build((join-path $solutionPath "AdventureWorks2008.sln"))
    
            copy-item (join-path $solutionPath (join-path "AdventureWorks2008\sql\Release" $schemaName)) $buildPath

            new-item (join-path $buildPath "StaticData") -type directory
            list-static-data-files $solutionPath | % { copy-item $_.FullName (join-path $buildPath "StaticData") }
        }

        function GetStaticTables
        {
            param ([string] $buildPath)
            
            , (get-static-table-scripts $buildPath  | % { $_.Name })
        }
        
        function Deploy
        {
            param ([object] $buildPath, [string] $databaseName)
            
            $database.DeploySchema((join-path $buildPath $schemaName), $databaseName)
            
            foreach($table in (get-static-table-scripts $buildPath))
            {
                $database.Execute($table.Path, $databaseName)
            } 
        }
        
        # ----

        function get-static-table-scripts
        {
            param ([string] $buildPath)

            $indexFile = get-static-data-indexfile $buildPath
            
            $tableNames = @()
            
            if (test-path $indexFile)
            {
                [xml]$index = get-content $indexFile
                
                foreach($table in $index.tables.table)
                {
                    $tableName = $table.name
                    $filePath = get-static-data-tablefile $buildPath $table.name
                    $tableNames += @($tupleFactory.Create(@("Name", $tableName, "Path", $filePath)))
                }
            }
            
            ,$tableNames
        }

        function get-static-data-tablefile()
        {
           param ([string] $buildPath, [string] $table)
           
           $staticDataPath = join-path $buildPath "StaticData"
           $tableFile = (join-path $staticDataPath ($table + ".sql"))
           
           if (!(test-path $tableFile))
           {
                throw ("Static data file for table '" + $table + "' is not found.")
           }
           
           $tableFile
        }

        function list-migrations
        {
            param($basePath)

            $migrationsPath = join-path $basePath "AdventureWorks2008\Scripts\Migrations"
                    
            if (test-path $migrationsPath)
            {
                get-childItem $migrationsPath "*.sql"
            }
            else
            {
                @()
            }
        }

        function get-static-data-indexfile()
        {
           param ([string] $buildPath)

           $staticDataPath = join-path $buildPath "StaticData"

           join-path $staticDataPath "index.xml"
        }

        function list-static-data-files
        {
            param ($basePath)

            $staticDataPath = join-path $basePath "AdventureWorks2008\Scripts\StaticData"
                     
            if (test-path $staticDataPath)
            {
                get-childItem $staticDataPath
            }
            else
            {
                @()
            }   
        }


        Export-ModuleMember -Variable * -Function *
    } -ArgumentList @($database, $msbuild) -asCustomObject  
}