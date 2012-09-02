function create-tfs-connector
{
    param($config)
    
    New-Module {
        param($config)

        function GetRevisionContents
        {
            param ([string] $targetFolder, [string] $version)
            
            $path = join-path $config.fakepath (join-path $version "*")
            
            copy-item $path -destination $targetFolder -recurse
        }
        
        function GetLatestRevision
        {
            get-childitem $config.fakepath | 
                %{ $_.Name} |
                %{ [int32]::parse($_) } | 
                sort |
                select -last 1
        }
        
        Export-ModuleMember -Variable * -Function *                
    } -ArgumentList $config -asCustomObject
}