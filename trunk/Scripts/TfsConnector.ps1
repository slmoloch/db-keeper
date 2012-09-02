function create-tfs-connector
{
    param($config)
    
    New-Module {
        param($config)

        function GetRevisionContents
        {
            param ([string] $targetFolder, [string] $version)

            $solutionCollection = $config.tfs_solutionCollection
            $solutionTfsPath = $config.tfs_solutionTfsPath
            $login = $config.tfs_login
            $password = $config.tfs_password 

            pushd $targetFolder
                        
            & $config.tfs_tool workspace /new /noprompt ci /collection:$solutionCollection /login:$login`,$password
            & $config.tfs_tool get $solutionTfsPath /version:$version /recursive /login:$login`,$password
            & $config.tfs_tool workspace /delete /noprompt ci /collection:$solutionCollection /login:$login`,$password

            popd
        }
        
        function GetLatestRevision
        {
            $solutionCollection = $config.tfs_solutionCollection
            $login = $config.tfs_login
            $password = $config.tfs_password 
            
            $a = & $config.tfs_tool changeset /collection:$solutionCollection /latest /login:$login`,$password
        
            $regex = [regex]'(\d+)'
            $revision = [int32]::parse($regex.Match($a).Value)
            
            if($revision -eq 0)
            {
                throw "Revision was not fetched correctly"
            }
            
            $revision
        }
        
        Export-ModuleMember -Variable * -Function *                
    } -ArgumentList $config -asCustomObject
}