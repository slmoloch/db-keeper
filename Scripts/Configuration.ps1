function create-config
{
    New-Module {
        [string] $msbuild_tool = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"
        [string] $vsdb_tool = "C:\Program Files\Microsoft Visual Studio 10.0\VSTSDB\Deploy\vsdbcmd.exe"
        [string] $sqlcmd_tool = "c:\Program Files\Microsoft SQL Server\100\Tools\Binn\SQLCMD.EXE"
        [string] $tablefiff_tool = "C:\Program Files\Microsoft SQL Server\100\COM\tablediff.exe"
        [string] $tfs_tool = "c:\Program Files\Microsoft Visual Studio 10.0\Common7\IDE\tf.exe"
        [string] $ocdb_tool = "d:\Tools\OpenDBDiff\OCDB.exe"
        [string] $dbadvance_tool = "d:\Tools\DbAdvance\DbAdvance.Host.exe"
        [string] $sqlpubwiz_tool = "C:\Program Files\Microsoft SQL Server\90\Tools\Publishing\1.4\SqlPubWiz.exe"
        
        [string] $tfs_login = "*"
        [string] $tfs_password = "*"
        [string] $tfs_solutionCollection = "*"
        [string] $tfs_solutionTfsPath = "*"
        
        [string] $serverName = "(local)\sqlexpress"
        [string] $connectionString = "Data Source=" + $serverName + ";Integrated Security=SSPI;"
        
        [string] $schemaName = "TestDatabase.dbschema"
        [string] $databaseName = "TestDatabase"
        
        [string] $outputPath = "d:\personal\Work\database-output\"
        [string] $fakepath = "d:\personal\Work\database-fake-source-control\"
        
        Export-ModuleMember -Variable * -Function *
    } -asCustomObject  
}