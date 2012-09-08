$MsBuildClass = new-psclass MsBuild `
{
    note -private Config
  
    constructor {
        param ($config)
        $private.Config = $config
    }

    method Build {
        param ([string] $solutionPath)

        & $config.msbuild_tool $solutionPath /p:Configuration=Release /t:Clean | Out-Default

        if($LastExitCode -ne 0)
        {
            throw "msbuild: cleaning $solutionPath failed. Check logs."
        }

        $out = & $config.msbuild_tool $solutionPath /p:Configuration=Release /t:Build | Out-Default

        if($LastExitCode -ne 0)
        {
            throw "msbuild: building $solutionPath failed. Check logs."
        }
    }
}