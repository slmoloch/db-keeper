function create-msbuild
{
    param($config)
    
    New-Module {
        param($config)
        
        function Build
        {
            param ([string] $solutionPath)

            & $config.msbuild_tool $solutionPath /p:Configuration=Release /t:Clean
            & $config.msbuild_tool $solutionPath /p:Configuration=Release /t:Build
        }
        
        Export-ModuleMember -Variable * -Function *                
    } -ArgumentList $config -asCustomObject  
}