$WorkflowClass = new-psclass Workflow `
{
    note -private TupleFactory
    note -private MaterialSource
    note -private VersionControl
    note -private FoldersStructure
    note -private Database
    note -private FileSystem
    note -private Config

    constructor {
        param($tupleFactory, $materialSource, $versionControl, $foldersStructure, $database, $fileSystem, $config)

        $private.TupleFactory = $tupleFactory
        $private.MaterialSource = $materialSource
        $private.VersionControl = $versionControl
        $private.FoldersStructure = $foldersStructure
        $private.Database = $database
        $private.FileSystem = $fileSystem
        $private.Config = $config
    }
    
    method -private DeltaFromMigrations {
        param ([object[]] $migrations)

        if($migrations -eq $null)
        {
            return , @()
        }
            
        $deltas = $migrations |
            %{ $private.TupleFactory.Create(@("FromVersion", $_[0], "ToVersion", $_[1])) } |
            sort-object -property FromVersion
                
        $deltas |
            ?{ $_.FromVersion -eq $_.ToVersion } |
            %{ throw "Source version can not be equal to destination version"}

        $deltas | 
            ?{ $_.FromVersion -ge $_.ToVersion } |
            %{ throw "Source version can not be greater to destination version"}
            
        $deltas
    }

    method -private DeltaFromArray {
        param ([int[]] $versions)
            
        $deltas = @()
        $prevVersion = $versions | select -first 1
            
        foreach ($version in ($versions | select -skip 1))
        {  	
            $deltas += $private.TupleFactory.Create(@("FromVersion", $prevVersion, "ToVersion", $version))
            $prevVersion = $version
        }
            
        $deltas |
            ?{ $_.FromVersion -ge $_.ToVersion} |
            %{ throw "Source version can not be greater or equal to destination version"}
            
        $deltas
    }


    method -private CoalesceTransitionsAndMigrations {
        param ([object[]] $transitions, [object[]] $migrations)
            
        $deltas = $transitions | %{ $private.TupleFactory.Create(@("FromVersion", $_.FromVersion, "ToVersion", $_.ToVersion, "Type", "Splittable")) }
            
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
                $deltas += $private.TupleFactory.Create(@("FromVersion", $delta.FromVersion, "ToVersion", $migration.FromVersion, "Type", "Splittable"))
            }
                
            $deltas += $private.TupleFactory.Create(@("FromVersion", $migration.FromVersion, "ToVersion", $migration.ToVersion, "Type", "Fixed"))
                
            if($migration.ToVersion -ne $delta.ToVersion)
            {
                $deltas += $private.TupleFactory.Create(@("FromVersion", $migration.ToVersion, "ToVersion", $delta.ToVersion, "Type", "Splittable"))
            }
        }
            
        $deltas | 
            sort-object -property FromVersion | 
            %{ $isMigration = $_.Type -eq "Fixed"; $private.TupleFactory.Create(@("FromVersion", $_.FromVersion, "ToVersion", $_.ToVersion, "IsMigration", $isMigration)) }
    }

    method -private GetDeltas {
        param ([int] $latestVersion, [string] $solutionPath)
            
        $versions    = ,0 + $private.MaterialSource.GetTransitionVersions($solutionPath) + ,$latestVersion
        $transitions = $private.DeltaFromArray($versions)
        $migrations  = $private.DeltaFromMigrations($private.MaterialSource.GetMigrations($solutionPath))

        $private.CoalesceTransitionsAndMigrations($transitions, $migrations)
    }

    method -private CreateMigrationDelta {
        param ([string] $solutionPath, [object] $deltaPackage, [object] $delta)
            
        copy-item $private.MaterialSource.GetMigrationPath($solutionPath, $delta.FromVersion, $delta.ToVersion) $deltaPackage.SchemaPath()
        copy-item $private.MaterialSource.GetMigrationPath($solutionPath, $delta.ToVersion, $delta.FromVersion) $deltaPackage.RollbackSchemaPath()
    }


    method -private CreateTransitionDelta {
        param ([string] $destinationBuildPath, [object] $deltaPackage, [object] $delta)
            
        $sourceDatabaseName = $private.Config.databaseName + $delta.FromVersion
        $destinationDatabaseName = $private.Config.databaseName + $delta.ToVersion
        $tailDatabaseName = $private.Config.databaseName + "_tail_" + $delta.FromVersion

        if($delta.FromVersion -eq 0)
        {
            $private.Database.ScriptDatabase($sourceDatabaseName, $destinationDatabaseName, $private.Config.databaseName, $deltaPackage.SchemaPath())
            $private.Database.GenerateDropScript($private.Config.databaseName, $deltaPackage.RollbackSchemaPath())
        }
        else
        {
            $private.Database.CompareDatabases($sourceDatabaseName, $destinationDatabaseName, $deltaPackage.SchemaPath())
            $private.Database.CompareDatabases($destinationDatabaseName, $sourceDatabaseName, $deltaPackage.RollbackSchemaPath())
        }

        $private.Database.Execute($deltaPackage.SchemaPath(), $tailDatabaseName)

        $staticTables = $private.MaterialSource.GetStaticTables($destinationBuildPath)

        $private.Database.CompareTables($tailDatabaseName, $destinationDatabaseName, $staticTables, { param($name) $deltaPackage.StaticDataPath($name) })
        $private.Database.CompareTables($destinationDatabaseName, $tailDatabaseName, $staticTables, { param($name) $deltaPackage.RollbackStaticDataPath($name) })
    }


    method -private CheckVersion {
        param ([string] $tempPath, [string] $buildPath, [int] $version, [string] $op)
            
        if($version -eq 0)
        {
            if($private.Database.Exists($private.Config.databaseName))
            {
                throw "Database was not removed by rollback of initial delta"
            }
                
            return
        }
            
        $deltaFile = join-path $tempPath "delta.sql"
        $snapshotDatabaseName = $private.Config.databaseName + $version
                
        $private.Database.CompareDatabases($private.Config.databaseName, $snapshotDatabaseName, $deltaFile)
                
        $content = (get-content $deltaFile)
                
        $content | 
            ? { $_ -ne ""} | 
            % { 
                write-host "-- delta starts here"
                write-host $content
                throw "The database created by sequential $op of deltas to version $version doesn't match snapshot of version $version from sources. Check custom migration of that version."
              } 

        $deltaFiles = New-Object System.Collections.ArrayList
            
        $nameProvider = { param($name)  $file=(join-path $tempPath "data-$name.sql"); $deltaFiles.Add($file) | out-null; $file }
            
        # TODO : get all table names from the database here, do not use slice info.
        $staticTables = $private.MaterialSource.GetStaticTables($buildPath)
                        
        $private.Database.CompareTables($private.Config.databaseName, $snapshotDatabaseName, $staticTables, $nameProvider)

        $content = $deltaFiles | 
            ? { test-path $_ } |
            % { get-content $_ }
            
        $content |  
            ? {$_ -ne "" -and $_ -ne $null} |
            % { 
                write-host "-- delta starts here"
                write-host $content
                throw "The database created by sequential $op of deltas to version $version doesn't match snapshot of version $version from sources. Check custom migration of that version." 
              } 
    }
    
    method Main {
            
        write-host "Calculating deltas ..."

        $latestVersion = $private.VersionControl.GetLatestRevision()
            
        $solutionPath = $private.FoldersStructure.NewSolutionPackage()
        $private.VersionControl.GetRevisionContents($solutionPath, $latestVersion)

        $deltas = $private.GetDeltas($latestVersion, $solutionPath)

        $firstDelta = $deltas | select -first 1
        $lastDelta = $deltas | select -last 1
        
        Write-Output $deltas | Out-Default

        Write-Host ""
        Write-Host ""
        Write-Host "Building slices ..."

        foreach($delta in $deltas)
        {   
            Write-Host ("#" + ("{0:D4}" -f $delta.ToVersion) + " ----------------------------------")

            $solutionPath = $private.FoldersStructure.NewSolutionPackage()
            $buildPath = $private.FoldersStructure.NewSlicePackage($delta.ToVersion)    
                
            $private.VersionControl.GetRevisionContents($solutionPath, $delta.ToVersion)
            $private.MaterialSource.Build($solutionPath, $buildPath)
        }

        Write-Host ""
        Write-Host ""
        Write-Host "Deploy databases for comparison ..."

        Write-Host ("#" + ("{0:D4}" -f 0) + " ----------------------------------")

        $databaseName = $private.Config.databaseName + "0"
        $private.Database.DropDatabase($databaseName)
        $private.Database.CreateEmptyDatabase($databaseName)

        $databaseName = $private.Config.databaseName + "_tail_0"
        $private.Database.DropDatabase($databaseName)
        $private.Database.CreateEmptyDatabase($databaseName)

        foreach ($delta in $deltas)
        {
            Write-Host ("#" + ("{0:D4}" -f $delta.ToVersion) + " ----------------------------------")

            $buildPath = $private.FoldersStructure.GetSlicePackage($delta.ToVersion)
                
            $tailDatabaseName = $private.Config.databaseName + "_tail_" + $delta.ToVersion
            $destinationDatabaseName = $private.Config.databaseName + $delta.ToVersion
                
            $private.Database.DropDatabase($tailDatabaseName)
            $private.Database.DropDatabase($destinationDatabaseName)

            $private.MaterialSource.Deploy($buildPath, $tailDatabaseName)
            $private.MaterialSource.Deploy($buildPath, $destinationDatabaseName)
        }

        Write-Host ""
        Write-Host ""
        Write-Host "Create Deltas ..."

        # initial delta
        $solutionPath = $private.FoldersStructure.NewSolutionPackage()
        $private.VersionControl.GetRevisionContents($solutionPath, $lastDelta.ToVersion)

        $deltaPackage = $private.FoldersStructure.NewDeltaPackage($firstDelta.ToVersion)
        $buildPath = $private.FoldersStructure.GetSlicePackage($firstDelta.ToVersion)

        create-transition-delta $buildPath $deltaPackage $firstDelta $true

        # deltas
        foreach ($delta in ($deltas | select -skip 1))
        {
            $deltaPackage = $private.FoldersStructure.NewDeltaPackage($delta.ToVersion)
                
            if ($delta.IsMigration)
            {      
                create-migration-delta $solutionPath $deltaPackage $delta
            }
            else
            {
                $destinationBuildPath = $private.FoldersStructure.GetSlicePackage($delta.ToVersion)
                    
                create-transition-delta $destinationBuildPath $deltaPackage $delta $false
            }
        }

        # package file
        $private.FileSystem.Recreate($private.Config.outputPath)
        $zipfile = join-path $private.Config.outputPath ("build-" + $lastdelta.ToVersion + ".zip")
                
        foreach ($delta in $deltas)
        {        
            $deltaPackage = $private.FoldersStructure.GetDeltaPackage($delta.ToVersion)
                
            get-childItem $deltaPackage.Root() -recurse | 
                export-zip $zipfile -EntryRoot $private.FoldersStructure.deltasPath -Append | 
                out-null
        }

        # check package file
        $private.Database.DropDatabase($private.Config.databaseName)

        foreach ($delta in $deltas)
        {
            $version = $delta.ToVersion
                
            $buildPath = $private.FoldersStructure.GetSlicePackage($version)
            $tempPath = $private.FoldersStructure.NewCheckDeltaPath()
                
            $private.Database.DeployPackageToVersion($private.Config.databaseName, $zipfile, $version)
                
            check-version $tempPath $buildPath $version "commit"
        }

        foreach ($delta in ($deltas | sort FromVersion -descending))
        {
            $version = $delta.FromVersion
                
            $buildPath = $private.FoldersStructure.GetSlicePackage($version)
            $tempPath = $private.FoldersStructure.NewCheckDeltaPath()

            $private.Database.RollbackPackageToVersion($private.Config.databaseName, $zipfile, $version)
                
            check-version $tempPath $buildPath $version "rollback"
        }

        # drop databases
        $databaseName = $private.Config.databaseName + "0"
        $private.Database.DropDatabase($databaseName)

        foreach ($delta in $deltas)
        {  
            $tailDatabaseName = $private.Config.databaseName + "_tail_" + $delta.ToVersion
            $destinationDatabaseName = $private.Config.databaseName + $delta.ToVersion
                
            $private.Database.DropDatabase($tailDatabaseName)
            $private.Database.DropDatabase($destinationDatabaseName)
        }

        # done!
    }
}
