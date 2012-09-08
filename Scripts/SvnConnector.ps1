$VersionControlClass = new-psclass VersionControl `
{
    note -private Config
  
    constructor {
        param ($config)
        $private.Config = $config
    }

    method GetRevisionContents {
        param ([string] $targetFolder, [string] $version)

        & $config.svn_tool export -r $version --force $config.svn_solution_url $targetFolder | Out-Default

        if($LastExitCode -ne 0)
        {
            throw "svn: sources fetching failed"
        }
    }

    method GetLatestRevision {
        [xml] $xml = & $config.svn_tool info --xml $config.svn_solution_url   

        if($LastExitCode -ne 0)
        {
            throw "svn: request failed"
        }

        $xml.info.entry.commit.revision 
    }
}