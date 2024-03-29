function create-config
{
    New-Module {
        $tfs_tool = "c:\Program Files\Microsoft Visual Studio 10.0\Common7\IDE\tf.exe"
        $svn_tool = "z:\Tools\SlikSvn\bin\svn.exe"
        $fakepath = "d:\personal\Work\database-fake-source-control\"


        $msbuild_tool = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"
        $vsdb_tool = "C:\Program Files\Microsoft Visual Studio 10.0\VSTSDB\Deploy\vsdbcmd.exe"
        $sqlcmd_tool = "c:\Program Files\Microsoft SQL Server\100\Tools\Binn\SQLCMD.EXE"
        $tablefiff_tool = "C:\Program Files\Microsoft SQL Server\100\COM\tablediff.exe"

        $ocdb_tool = "d:\Tools\OpenDBDiff\OCDB.exe"
        $dbadvance_tool = "d:\Tools\DbAdvance\DbAdvance.Host.exe"
        $sqlpubwiz_tool = "C:\Program Files\Microsoft SQL Server\90\Tools\Publishing\1.4\SqlPubWiz.exe"
        
        $tfs_login = "*"
        $tfs_password = "*"
        $tfs_solutionCollection = "*"
        $tfs_solutionTfsPath = "*"

        $svn_solution_url = "https://db-keeper.googlecode.com/svn/trunk/SampleDatabases/MicrosoftDatabaseProject"
        
        $serverName = "(local)\sqlexpress"
        $connectionString = "Data Source=" + $serverName + ";Integrated Security=SSPI;"
        
        $schemaName = "TestDatabase.dbschema"
        $databaseName = "TestDatabase"
        
        $outputPath = "d:\personal\Work\database-output\"
        
        Export-ModuleMember -Variable * -Function *
    } -asCustomObject  
}