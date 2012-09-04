function new-folder-structure
{
    param($config, $fileSystem)
    
    New-Module {
        param ($config, $fileSystem)

        $tempFolder = join-path $env:temp ("db-" + $config.databaseName)
        $sourcesFolder = join-path $tempFolder "Sources"
        $slicesFolder = join-path $tempFolder "Slices"
        $migrationsFolder = join-path $tempFolder "Migration"
        $deltasPath = join-path $tempFolder "Deltas"
        $checkDeltaPath = join-path $tempFolder "CheckDelta"
        
        function NewSolutionPackage
        {
            $fileSystem.Recreate($sourcesFolder)
            $sourcesFolder
        }  
        
        function NewSlicePackage
        {
            param ($version)
            
            $sliceFolder = join-path $slicesFolder $version
            $fileSystem.Recreate($sliceFolder)
            $sliceFolder
        }
        
        function GetSlicePackage
        {
            param ($version)
            
            $sliceFolder = join-path $slicesFolder $version
            $sliceFolder
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
    } -ArgumentList @($config, $fileSystem) -asCustomObject    
}