function new-version-control
{
    param($config)
    
    New-Module {
        param($config)

        function GetRevisionContents
        {
            param ([string] $targetFolder, [string] $version)
            
            & $config.svn_tool export --force $config.svn_solution_url $targetFolder
        }
        
        function GetLatestRevision
        {
            [xml] $xml = & $config.svn_tool info --xml $config.svn_solution_url
            
            $xml.info.entry.commit.revision
        }
        
        Export-ModuleMember -Variable * -Function *                
    } -ArgumentList $config -asCustomObject
}