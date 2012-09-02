function create-workflow
{
    param($tupleFactory, $materialSource, $sourceControl, $foldersStructure, $database, $fileSystem)
    
    New-Module {        
        param($tupleFactory, $materialSource, $sourceControl, $foldersStructure, $database, $fileSystem)
        
        function delta-from-migrations
        {
            param ([object[]] $migrations)
            
            $deltas = $migrations |
                %{ $tupleFactory.Create(@("FromVersion", $_[0], "ToVersion", $_[1])) } |
                sort-object -property FromVersion
                
            $deltas |
                ?{ $_.FromVersion -eq $_.ToVersion } |
                %{ throw "Source version can not be equal to destination version"}

            $deltas | 
                ?{ $_.FromVersion -ge $_.ToVersion } |
                %{ throw "Source version can not be greater to destination version"}
            
            $deltas
        }

        function delta-from-array
        {
            param ([int[]] $versions)
            
            $deltas = @()
            $prevVersion = $versions | select -first 1
            
            foreach ($version in ($versions | select -skip 1))
            {  	
                $deltas += $tupleFactory.Create(@("FromVersion", $prevVersion, "ToVersion", $version))
                $prevVersion = $version
            }
            
            $deltas |
                ?{ $_.FromVersion -ge $_.ToVersion} |
                %{ throw "Source version can not be greater or equal to destination version"}
            
            $deltas
        }

        function coalesce-transitions-and-migrations
        {
            param ([object[]] $transitions, [object[]] $migrations)
            
            $deltas = $transitions | %{ $tupleFactory.Create(@("FromVersion", $_.FromVersion, "ToVersion", $_.ToVersion, "Type", "Splittable")) }
            
            # system has to ignore migrations for versions less then the first transition
            # the forst transition is the special, "artificial" one - this is just transition from void to the first available version of the database in 
            # source control. Usually this is the version when database was initiallu put under source control, however
            # development team can push it to prevent redundant delta calculations during the build.
            
            # migrations which from version is less than the first transition delta fail coalesce operation since it doesnt fit to transitions
            
            $earliestVersion = ($transitions | sort-object -property FromVersion | select -first 1).ToVersion
            $migrations = $migrations | ? {$_.ToVersion -ge $earliestVersion }
            
            #--------------
            
            foreach ($migration in $migrations)
            {
                $delta = $deltas | 
                    ?{$migration.FromVersion -ge $_.FromVersion -and $migration.ToVersion -le $_.ToVersion} |
                    ?{"Splittable" -eq $_.Type} 
                
                if(($delta | Measure-Object).Count -ne 1)
                {
                    throw "Migration $version doesn't fit to any delta" 
                }
                
                $deltas |
                    ?{$migration.FromVersion -ge $_.FromVersion -and $migration.ToVersion -le $_.ToVersion} |
                    ?{"Fixed" -eq $_.Type} |
                    %{ throw "Migration $version overlaps with other migration $_" }
                
                $deltas |
                    ?{($migration.FromVersion -gt $_.FromVersion -and $migration.FromVersion -lt $_.ToVersion) -or ($migration.ToVersion -gt $_.FromVersion -and $migration.ToVersion -lt $_.ToVersion)} |
                    ?{"Fixed" -eq $_.Type} |
                    %{ throw "Migration $version overlaps with other migration $_" }
                    
                $deltas = @($deltas | ?{$_ -ne $delta}) 
                
                if($delta.FromVersion -ne $migration.FromVersion)
                {
                    $deltas += $tupleFactory.Create(@("FromVersion", $delta.FromVersion, "ToVersion", $migration.FromVersion, "Type", "Splittable"))
                }
                
                $deltas += $tupleFactory.Create(@("FromVersion", $migration.FromVersion, "ToVersion", $migration.ToVersion, "Type", "Fixed"))
                
                if($migration.ToVersion -ne $delta.ToVersion)
                {
                    $deltas += $tupleFactory.Create(@("FromVersion", $migration.ToVersion, "ToVersion", $delta.ToVersion, "Type", "Splittable"))
                }
            }
            
            $deltas | 
                sort-object -property FromVersion | 
                %{ $isMigration = $_.Type -eq "Fixed"; $tupleFactory.Create(@("FromVersion", $_.FromVersion, "ToVersion", $_.ToVersion, "IsMigration", $isMigration)) }
        }

        function get-deltas
        {
            param ([object] $materialSource, [object] $foldersStructure, [int] $latestVersion, [object] $solutionPackage)
            
            $versions    = ,0 + $materialSource.GetTransitionVersions($solutionPackage) + ,$latestVersion
            $transitions = delta-from-array $versions
            $migrations  = delta-from-migrations $materialSource.GetMigrations($solutionPackage)

            coalesce-transitions-and-migrations $transitions $migrations
        }

        function create-slice-package 
        {
            param([string] $packagePath)
            
            new-slice-package $config $packagePath $tupleFactory
        }

        function create-initial-snapshot
        {
            param ([object] $materialSource, [object] $config, [object] $delta, [object] $deltaPackage, [object] $slicePackage)
            
            $sourceDatabaseName = $config.databaseName + $delta.FromVersion
            $destinationDatabaseName = $config.databaseName + $delta.ToVersion

            $database.ScriptDatabase($sourceDatabaseName, $destinationDatabaseName, $config.databaseName, $deltaPackage.SchemaPath())
            $database.GenerateDropScript($config.databaseName, $deltaPackage.RollbackSchemaPath())
            $database.DropDatabase($config.databaseName)
            
            foreach($table in @($materialSource.GetStaticTables($slicePackage)))
            {               
                copy-item $table.Path $deltaPackage.StaticDataPath($table.Name)
            }
        }

        function create-migration-delta
        {
            param ([object] $materialSource, [object] $solutionPackage, [object] $deltaPackage, [object] $delta)
            
            copy-item $materialSource.GetMigrationPath($solutionPackage, $delta.FromVersion, $delta.ToVersion) $deltaPackage.SchemaPath()
            copy-item $materialSource.GetMigrationPath($solutionPackage, $delta.ToVersion, $delta.FromVersion) $deltaPackage.RollbackSchemaPath()
        }

        function create-transition-delta
        {
            param ([object] $materialSource, [object] $database, [object] $config, [object] $sourceSlicePackage, [object] $destinationSlicePackage, [object] $deltaPackage, [object] $delta)
            
            $sourceDatabaseName = $config.databaseName + $delta.FromVersion
            $destinationDatabaseName = $config.databaseName + $delta.ToVersion
            $tailDatabaseName = $config.databaseName + "_tail_" + $delta.FromVersion

            $database.CompareDatabases($sourceDatabaseName, $destinationDatabaseName, $deltaPackage.SchemaPath())
            $database.CompareDatabases($destinationDatabaseName, $sourceDatabaseName, $deltaPackage.RollbackSchemaPath())

            $database.Execute($deltaPackage.SchemaPath(), $tailDatabaseName)

            $staticTables = @($materialSource.GetStaticTables($destinationSlicePackage) | % { $_.Name })

            $database.CompareTables($tailDatabaseName, $destinationDatabaseName, $staticTables, { param($name) $deltaPackage.StaticDataPath($name) })
            $database.CompareTables($destinationDatabaseName, $tailDatabaseName, $staticTables, { param($name) $deltaPackage.RollbackStaticDataPath($name) })
        }

        function check-version
        {
            param ([object] $folderStructure, [object] $materialSource, [object] $slicePackage, [int] $version, [string] $op)
            
            if($version -eq 0)
            {
                if($database.Exists($config.databaseName))
                {
                    throw "Database was not removed by rollback of initial delta"
                }
                
                return
            }
            
            $tempPath = $folderStructure.NewCheckDeltaPath()
            
            $deltaFile = join-path $tempPath "delta.sql"
            $snapshotDatabaseName = $config.databaseName + $version
                
            $database.CompareDatabases($config.databaseName, $snapshotDatabaseName, $deltaFile)
                
            $content = (get-content $deltaFile)
                
            $content | 
                ? { $_ -ne ""} | 
                % { write-output "-- delta starts here"; write-output $content; throw "The database created by sequential $op of deltas to version $version doesn't match snapshot of version $version from sources. Check custom migration of that version." } 
            $deltaFiles = New-Object System.Collections.ArrayList
            
            $nameProvider = { param($name)  $file=(join-path $tempPath "data-$name.sql"); $deltaFiles.Add($file) | out-null; $file }
            
            # TODO : get all table names from the database here, do not use slice info.
            $staticTables = $materialSource.GetStaticTables($slicePackage) | % { $_.Name }
            
            $database.CompareTables($config.databaseName, $snapshotDatabaseName, $staticTables, $nameProvider)

            $content = $deltaFiles | 
                ? { test-path $_ } |
                % { get-content $_ }
            
            $content |  
                ? {$_ -ne "" -and $_ -ne $null} |
                % { write-output "-- delta starts here"; write-output $content; throw "The database created by sequential $op of deltas to version $version doesn't match snapshot of version $version from sources. Check custom migration of that version." } 
        }

        
        
        function Main()
        {
            $latestVersion = $versioncontrol.GetLatestRevision()

            $solutionPackage = $foldersStructure.NewSolutionPackage()
            $versioncontrol.GetRevisionContents($solutionPackage.Root(), $latestVersion)

            $deltas = get-deltas $materialSource $foldersStructure $latestVersion $solutionPackage
            $firstDelta = $deltas | select -first 1
            $lastDelta = $deltas | select -last 1

            write-output "Deltas:"
            write-output $deltas

            foreach($delta in $deltas)
            {   
                $solutionPackage = $foldersStructure.NewSolutionPackage()
                $slicePackage = $foldersStructure.NewSlicePackage($delta.ToVersion)    
                
                $versioncontrol.GetRevisionContents($solutionPackage.Root(), $delta.ToVersion)
                $materialSource.Build($solutionPackage, $slicePackage)
            }

            # deploy databases for comparison

            $databaseName = $config.databaseName + "0"
            $database.DropDatabase($databaseName)
            $database.CreateEmptyDatabase($databaseName)

            foreach ($delta in $deltas)
            {
                $slicePackage = $foldersStructure.GetSlicePackage($delta.ToVersion)
                
                $tailDatabaseName = $config.databaseName + "_tail_" + $delta.ToVersion
                $destinationDatabaseName = $config.databaseName + $delta.ToVersion
                
                $database.DropDatabase($tailDatabaseName)
                $database.DropDatabase($destinationDatabaseName)

                $materialSource.Deploy($slicePackage, $tailDatabaseName)
                $materialSource.Deploy($slicePackage, $destinationDatabaseName)
            }

            # initial delta
            $solutionPackage = $foldersStructure.NewSolutionPackage()
            $versioncontrol.GetRevisionContents($solutionPackage.Root(), $lastDelta.ToVersion)

            $deltaPackage = $foldersStructure.NewDeltaPackage($firstDelta.ToVersion)
            $slicePackage = $foldersStructure.GetSlicePackage($firstDelta.ToVersion)

            create-initial-snapshot $materialSource $config $firstDelta $deltaPackage $slicePackage

            # deltas
            foreach ($delta in ($deltas | select -skip 1))
            {
                $deltaPackage = $foldersStructure.NewDeltaPackage($delta.ToVersion)
                
                if ($delta.IsMigration)
                {      
                    create-migration-delta $materialSource $solutionPackage $deltaPackage $delta
                }
                else
                {
                    $sourceSlicePackage = $foldersStructure.GetSlicePackage($delta.FromVersion)
                    $destinationSlicePackage = $foldersStructure.GetSlicePackage($delta.ToVersion)
                    
                    create-transition-delta $materialSource $database $config $sourceSlicePackage $destinationSlicePackage $deltaPackage $delta
                }
            }

            # package file
            $fileSystem.Recreate($config.outputPath)
            $zipfile = join-path $config.outputPath ("build-" + $lastdelta.ToVersion + ".zip")
                
            foreach ($delta in $deltas)
            {        
                $deltaPackage = $foldersStructure.GetDeltaPackage($delta.ToVersion)
                
                get-childItem $deltaPackage.Root() -recurse | 
                    export-zip $zipfile -EntryRoot $foldersStructure.deltasPath -Append | 
                    out-null
            }

            # check package file
            $database.DropDatabase($config.databaseName)

            foreach ($delta in $deltas)
            {
                $version = $delta.ToVersion
                
                $slicePackage = $foldersStructure.GetSlicePackage($version)
                
                $database.DeployPackageToVersion($config.databaseName, $zipfile, $version)
                
                check-version $foldersStructure $materialSource $slicePackage $version "commit"
            }

            foreach ($delta in ($deltas | sort FromVersion -descending))
            {
                $version = $delta.FromVersion
                
                $slicePackage = $foldersStructure.GetSlicePackage($version)
                
                $database.RollbackPackageToVersion($config.databaseName, $zipfile, $version)
                
                check-version $foldersStructure $materialSource $slicePackage $version "rollback"
            }

            # drop databases
            $databaseName = $config.databaseName + "0"
            $database.DropDatabase($databaseName)

            foreach ($delta in $deltas)
            {  
                $tailDatabaseName = $config.databaseName + "_tail_" + $delta.ToVersion
                $destinationDatabaseName = $config.databaseName + $delta.ToVersion
                
                $database.DropDatabase($tailDatabaseName)
                $database.DropDatabase($destinationDatabaseName)
            }

            # done!
        }
        
        Export-ModuleMember -Variable * -Function *                
    } -ArgumentList @($tupleFactory, $materialSource, $sourceControl, $foldersStructure, $database, $fileSystem) -asCustomObject  
}