function new-material-source
{
    param($database, $msbuild)
     
    New-Module {
        param($database, $msbuild)

        $schemaName = "TestDatabase.dbschema"   

        function GetTransitionVersions
        {
            param ([string] $solutionPath)
            
            [xml] $xml = get-content (join-path (solution-base-path $solutionPath) "slices.xml")
            
            $xml.versions.version | 
                %{ [int32]::parse($_) }
        }
        
        function GetMigrations
        {
            param ([string] $solutionPath)
            
            (ListMigrations (solution-base-path $solutionPath)) |
                %{ $_.Name } |
                %{ 
                    $data = $_.replace(".sql", "").split("-")
                    
                    $fromVersion = [int32]::parse($data[0])
                    $toVersion = [int32]::parse($data[1])
                    
                    ,@($fromVersion, $toVersion)
                } |
                ?{ $_[0] -le $_[1] }
        }
           
        function GetMigrationPath
        {
            param ([string] $solutionPath, [int32] $from, [int32] $to)
            
            $migrationsPath = join-path (solution-base-path $solutionPath) "TestDatabase\Scripts\Migrations"
                    
            join-path $migrationsPath ($from.ToString() + "-" + $to.ToString() + ".sql")
        }
        
        function Build
        {
            param ([string] $solutionPath, [string] $buildPath)
            
            $basePath = solution-base-path $solutionPath

            $msbuild.Build((join-path $basePath "TestDatabase.sln"))
    
            copy-item (join-path $basePath (join-path "TestDatabase\sql\Release" $schemaName)) $buildPath

            new-item (join-path $buildPath "StaticData") -type directory
            list-static-data-files $basePath | % { copy-item $_.FullName (join-path $buildPath "StaticData") }
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

        function ListMigrations
        {
            param($solutionBasePath)

            $migrationsPath = join-path $solutionBasePath "TestDatabase\Scripts\Migrations"
                    
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

        function solution-base-path 
        { 
            param($sourcesPath) 
            
            join-path $sourcesPath "Scratchpad\Yauheni\DatabaseCi\TestDatabase" 
        }

        function list-static-data-files
        {
            param ($basePath)

            $staticDataPath = join-path $basePath "TestDatabase\Scripts\StaticData"
                     
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