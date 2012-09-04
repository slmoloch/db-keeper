$ErrorActionPreference = "stop"

#trap 
#{
#	"Error found: $_"
	#[Environment]::Exit(1)
#}

Import-Module .\PowershellZip\PowershellZip.dll

. .\msproj-fakevc-mssql-configuration.ps1

. .\FakeConnector.ps1
. .\MsBuild.ps1
. .\FileSystem.ps1
. .\DatabaseTools.ps1
. .\TupleFactory.ps1
. .\FolderStructure.ps1
. .\MaterialSource.ps1
. .\Workflow.ps1

$config = create-config
$fileSystem = create-filesystem
$tupleFactory = new-tuple-factory
$versionControl = new-version-control $config
$msbuild = create-msbuild $config
$database = create-database-tool $config
$foldersStructure = new-folder-structure $config $fileSystem
$materialSource = new-material-source $database $msbuild
$workflow = create-workflow $tupleFactory $materialSource $versionControl $foldersStructure $database $fileSystem $config

$workflow.Main()