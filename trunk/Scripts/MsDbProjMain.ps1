$ErrorActionPreference = "stop"

trap 
{
	"Error found: $_"
	#[Environment]::Exit(1)
}

Import-Module .\PowershellZip\PowershellZip.dll

. .\MsDbProjConfiguration.ps1
. .\SvnConnector.ps1
. .\MsBuild.ps1
. .\FileSystem.ps1
. .\DatabaseTools.ps1
. .\TupleFactory.ps1
. .\SlicesPackage.ps1
. .\SlicePackage.ps1
. .\FolderStructure.ps1
. .\MaterialSource.ps1
. .\Workflow.ps1

$config = create-config
$fileSystem = create-filesystem
$tupleFactory = new-tuple-factory
$versioncontrol = new-version-control $config
$msbuild = create-msbuild $config
$database = create-database-tool $config
$foldersStructure = new-folder-structure $config $tupleFactory $fileSystem
$materialSource = new-material-source $database $msbuild
$workflow = create-workflow $tupleFactory $materialSource $sourceControl $foldersStructure $database $fileSystem

$workflow.Main()