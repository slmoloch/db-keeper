function new-material-source
{
    param($database, $msbuild)
     
    New-Module {
        param($database, $msbuild)

        function GetTransitionVersions
        {
            param ([object] $solutionPackage)
            
            [xml]$xml = get-content $solutionPackage.ReleaseRevisionsPath()
            
            $xml.versions.version | 
                %{ [int32]::parse($_) }
        }
        
        function GetMigrations
        {
            param ([object] $solutionPackage)
            
            $solutionPackage.ListMigrations() |
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
            param ([object] $solutionPackage, [int32] $fromVersion, [int32] $toVersion)
            
            $solutionPackage.GetMigration($fromVersion, $toVersion)
        }
        
        function Build
        {
            param ([object] $solutionPackage, [object] $slicePackage)
            
            $msbuild.Build($solutionPackage.SolutionPath())
    	
            $slicePackage.CopyToRoot($solutionPackage.ReleasePath())
            $slicePackage.CopyToStaticData($solutionPackage.ListStaticDataFiles())
        }
        
        function GetStaticTables
        {
            param ([object] $slicePackage)
            
            $slicePackage.GetStaticDataScripts()
        }
        
        function Deploy
        {
            param ([object] $slicePackage, [string] $databaseName)
            
            $database.DeploySchema($slicePackage.GetSchemaPath(), $databaseName)
            
            foreach($table in $slicePackage.GetStaticDataScripts())
            {
                $database.Execute($table.Path, $databaseName)
            } 
        }
        
        Export-ModuleMember -Variable * -Function *
    } -ArgumentList @($database, $msbuild) -asCustomObject  
}