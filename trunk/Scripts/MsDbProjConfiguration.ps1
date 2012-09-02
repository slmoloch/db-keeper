function create-config
{
    New-Module {
        $svn_tool = "z:\Tools\SlikSvn\bin\svn.exe"        
        $msbuild_tool = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"
        $vsdb_tool = "C:\Program Files\Microsoft Visual Studio 10.0\VSTSDB\Deploy\vsdbcmd.exe"
        $sqlcmd_tool = "c:\Program Files\Microsoft SQL Server\100\Tools\Binn\SQLCMD.EXE"
        $tablefiff_tool = "C:\Program Files\Microsoft SQL Server\100\COM\tablediff.exe"
        $ocdb_tool = "d:\Tools\OpenDBDiff\OCDB.exe"
        $dbadvance_tool = "d:\Tools\DbAdvance\DbAdvance.Host.exe"

        
        $svn_solution_url = "https://db-keeper.googlecode.com/svn/trunk/SampleDatabases/MicrosoftDatabaseProject"
        
        $serverName = "(local)\sqlexpress"
        $connectionString = "Data Source=" + $serverName + ";Integrated Security=SSPI;"
        
        $schemaName = "TestDatabase.dbschema"
        $databaseName = "TestDatabase"
        
        $outputPath = "z:\Moloch\Work\Projects\db-keeper\temp\MsDbProj\"
        
        Export-ModuleMember -Variable * -Function *
    } -asCustomObject  
}