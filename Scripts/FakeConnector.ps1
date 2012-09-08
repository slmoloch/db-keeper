$VersionControlClass = new-psclass VersionControl `
{
    note -private Config
  
    constructor {
        param ($config)
        $private.Config = $config
    }

    method GetRevisionContents { 
        param ([string] $targetFolder, [string] $version)
            
        $path = join-path $private.Config.fakepath (join-path $version "*")
            
        copy-item $path -destination $targetFolder -recurse
    }

    method GetLatestRevision { 
        get-childitem $config.fakepath | 
            %{ $_.Name} |
            %{ [int32]::parse($_) } | 
            sort |
            select -last 1
    }
} 