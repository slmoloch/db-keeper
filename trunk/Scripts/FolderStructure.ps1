function new-folder-structure
{
    param($config, $tupleFactory, $fileSystem)
    
    New-Module {
        param ($config, $tupleFactory, $fileSystem)

        $tempFolder = join-path $env:temp "database-automation"
        $sourcesFolder = join-path $tempFolder "Sources"
        $slicesFolder = join-path $tempFolder "Slices"
        $migrationsFolder = join-path $tempFolder "Migration"
        $deltasPath = join-path $tempFolder "Deltas"
        $checkDeltaPath = join-path $tempFolder "CheckDelta"
        
        function NewSolutionPackage
        {
            $solutionPackage = new-solution-package $sourcesFolder $fileSystem
            $solutionPackage.Init()
            $solutionPackage
        }  
        
        function NewSlicesPackage
        {
            $slicesPackage = new-slices-package $filesystem $slicesFolde
            $slicesPackage.Init() 
            $slicesPackage
        }     
        
        function NewSlicePackage
        {
            param ($version)
            
            $sliceFolder = join-path $slicesFolder $version
            $slicePackage = new-slice-package $config $sliceFolder $tupleFactory $fileSystem
            $slicepackage.Init()
            $slicepackage
        }
        
        function GetSlicePackage
        {
            param ($version)
            
            $sliceFolder = join-path $slicesFolder $version
            $slicePackage = new-slice-package $config $sliceFolder $tupleFactory $fileSystem
            $slicepackage
        }
        
        function NewDeltaPackage
        {
            param ($version)
            
            $deltaPackage = new-delta-package (join-path $deltasPath $version) $fileSystem
            $deltaPackage.Init()
            $deltaPackage
        }
        
        function GetDeltaPackage
        {
            param ($version)
            
            $deltaPackage = new-delta-package (join-path $deltasPath $version) $fileSystem
            $deltaPackage
        }
        
        function NewCheckDeltaPath
        {
            $fileSystem.Recreate($checkDeltaPath)
            
            $checkDeltaPath
        }

        function new-solution-package
        {
            param($sourcesPath, $fileSystem)
            
            New-Module {
                param ($sourcesPath, $fileSystem)
                
                $schemaName = "TestDatabase.dbschema"
            
                $solutionBasePath = join-path $sourcesPath "Scratchpad\Yauheni\DatabaseCi\TestDatabase"    
               
                function StaticDataPath
                {
                    param ($tableName)
                    
                    join-path (join-path $deltaFolder "Commit") ("data_" + $tableName + ".sql")
                }
                
                function Root
                {
                    $sourcesPath
                }
                
                function Init
                {
                    $fileSystem.Recreate($sourcesPath)
                }
                
                function ReleasePath
                {
                    join-path $solutionBasePath (join-path "TestDatabase\sql\Release" $schemaName)
                }
                
                function SolutionPath
                {
                    join-path $solutionBasePath "TestDatabase.sln"
                }
                
                function ReleaseRevisionsPath
                {
                    join-path $solutionBasePath "slices.xml"
                }
                
                function GetMigration
                {
                    param ([int] $from, [int] $to)
                    
                    $migrationsPath = join-path $solutionBasePath "TestDatabase\Scripts\Migrations"
                    
                    join-path $migrationsPath ($from.ToString() + "-" + $to.ToString() + ".sql")
                }
                
                function ListMigrations
                {
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
                
                function ListStaticDataFiles
                {
                    $staticDataPath = join-path $solutionBasePath "TestDatabase\Scripts\StaticData"
                     
                    if (test-path $staticDataPath)
                    {
                        get-childItem $staticDataPath
                    }
                    else
                    {
                        @()
                    }   
                }
                
                Export-ModuleMember -Function *                
            } -ArgumentList @($sourcesPath, $fileSystem) -asCustomObject  
        }
        
        function new-delta-package
        {
            param($deltaFolder, $fileSystem)
            
            New-Module {
                param($deltaFolder, $fileSystem)
                
                $commitCounter = 2
                $rollbackCounter = 998
                
                function Root
                {
                    $deltaFolder
                }
                
                function SchemaPath()
                {
                    join-path (join-path $deltaFolder "Commit") "001.schema.sql"            
                }
                
                function RollbackSchemaPath()
                {
                    join-path (join-path $deltaFolder "Rollback") "999.schema.sql"            
                }
                
                function StaticDataPath
                {
                    param($tableName)
                    
                    join-path (join-path $deltaFolder "Commit") (("{0:D3}" -f ($commitCounter ++)) + ".data_" + $tableName + ".sql")
                }
                
                function RollbackStaticDataPath
                {
                    param($tableName)
                    
                    join-path (join-path $deltaFolder "Rollback") (("{0:D3}" -f ($rollbackCounter --)) + ".data_" + $tableName + ".sql")
                }
                
                function Init
                {
                    $fileSystem.Recreate($deltaFolder)
                    $fileSystem.Recreate((join-path $deltaFolder "Commit"))
                    $fileSystem.Recreate((join-path $deltaFolder "Rollback"))
                    
                    $commitCounter = 2
                    $rollbackCounter = 998
                }
                
                Export-ModuleMember -Variable * -Function *
            } -ArgumentList @($deltaFolder, $fileSystem) -asCustomObject  
        }
        
        Export-ModuleMember -Variable * -Function *                
    } -ArgumentList @($config, $tupleFactory, $fileSystem) -asCustomObject    
}