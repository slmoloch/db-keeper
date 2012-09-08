$ErrorActionPreference = "stop"

Import-Module .\PowershellZip\PowershellZip.dll


. .\PSClass.ps1
. .\msproj-svn-mssql-configuration.ps1
. .\msproj-svn-mssql-materialsource.ps1

. .\SvnConnector.ps1
. .\MsBuild.ps1

. .\FileSystem.ps1
. .\DatabaseTools.ps1
. .\TupleFactory.ps1
. .\FolderStructure.ps1
. .\Workflow.ps1


$config = create-config
$fileSystem = create-filesystem
$tupleFactory = new-tuple-factory

$versionControl = $VersionControlClass.New($config)
$msbuild = $MsBuildClass.New($config)
$database = $DatabaseClass.New($config)

$foldersStructure = new-folder-structure $config $fileSystem
$materialSource = $MaterialSourceClass.New($database, $msbuild)

$workflow = $WorkflowClass.New($tupleFactory, $materialSource, $versionControl, $foldersStructure, $database, $fileSystem, $config)

$workflow.Main()