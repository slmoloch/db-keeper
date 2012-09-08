$MaterialSourceClass = new-psclass MaterialSource `
{
    note -private MsBuild
    note -private Database
    note -private SchemaName
    

    constructor {
        param($database, $msbuild)

        $private.MsBuild = $msbuild
        $private.Database = $database
        $private.SchemaName = "AdventureWorks2008.dbschema"
    }

    method GetTransitionVersions {
        param ([string] $solutionPath)
            
        [xml] $xml = get-content (join-path $solutionPath "slices.xml")
            
        $xml.versions.version | 
            %{ [int32]::parse($_) }
    }

        
    method GetMigrations {
        param ([string] $solutionPath)
            
        , ($private.ListMigrations($solutionPath) |
            %{ $_.Name } |
            %{ 
                $data = $_.replace(".sql", "").split("-")
                    
                $fromVersion = [int32]::parse($data[0])
                $toVersion = [int32]::parse($data[1])
                    
                ,@($fromVersion, $toVersion)
            } |
            ?{ $_[0] -le $_[1] })
    }

    method GetMigrationPath {
        param ([string] $solutionPath, [int32] $from, [int32] $to)
            
        $migrationsPath = join-path $solutionPath "AdventureWorks2008\Scripts\Migrations"
                    
        join-path $migrationsPath ($from.ToString() + "-" + $to.ToString() + ".sql")
    }

    method Build {
        param ([string] $solutionPath, [string] $buildPath)
            
        $msbuild.Build((join-path $solutionPath "AdventureWorks2008.sln"))
    
        copy-item (join-path $solutionPath (join-path "AdventureWorks2008\sql\Release" $private.SchemaName)) $buildPath

        new-item (join-path $buildPath "StaticData") -type directory

        $private.ListStaticDataFiles($solutionPath) | % { copy-item $_.FullName (join-path $buildPath "StaticData") }
    }

    method GetStaticTables {
        param ([string] $buildPath)
            
        , ($private.GetStaticTableScripts($buildPath)  | % { $_.Name })
    }
        
    method Deploy {
        param ([object] $buildPath, [string] $databaseName)
            
        $database.DeploySchema((join-path $buildPath $private.SchemaName), $databaseName)
            
        foreach($table in ($private.GetStaticTableScripts($buildPath)))
        {
            $database.Execute($table.Path, $databaseName)
        } 
    }

    # ----
    method -private GetStaticTableScripts {
        param ([string] $buildPath)

        $indexFile = $private.GetStaticDataIndexfile($buildPath)
            
        $tableNames = @()
            
        if (test-path $indexFile)
        {
            [xml]$index = get-content $indexFile
                
            foreach($table in $index.tables.table)
            {
                $tableName = $table.name
                $filePath = $private.GetStaticDataTablefile($buildPath, $table.name)

                $tableNames += @($tupleFactory.Create(@("Name", $tableName, "Path", $filePath)))
            }
        }
            
        ,$tableNames
    }

    method -private GetStaticDataTablefile {
        param ([string] $buildPath, [string] $table)
           
        $staticDataPath = join-path $buildPath "StaticData"
        $tableFile = (join-path $staticDataPath ($table + ".sql"))
           
        if (!(test-path $tableFile))
        {
            throw ("Static data file for table '" + $table + "' is not found.")
        }
           
        $tableFile
    }

    method -private ListMigrations {
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

    method -private GetStaticDataIndexfile {
        param ([string] $buildPath)

        $staticDataPath = join-path $buildPath "StaticData"

        join-path $staticDataPath "index.xml"
    }

    method -private ListStaticDataFiles {
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
}