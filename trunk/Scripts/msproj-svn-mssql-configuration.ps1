function create-config
{
    New-Module {
        $svn_tool = "z:\Tools\SlikSvn\bin\svn.exe" 
        $svn_solution_url = "https://db-keeper.googlecode.com/svn/trunk/SampleDatabases/MicrosoftDatabaseProject"
               
        $msbuild_tool = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"
        $vsdb_tool = "C:\Program Files\Microsoft Visual Studio 10.0\VSTSDB\Deploy\vsdbcmd.exe"
        $sqlcmd_tool = "c:\Program Files\Microsoft SQL Server\100\Tools\Binn\SQLCMD.EXE"
        $tablediff_tool = "C:\Program Files\Microsoft SQL Server\100\COM\tablediff.exe"
        $ocdb_tool = "z:\Tools\OpenDbDiff\OCDB.exe"
        $dbadvance_tool = "z:\Tools\DbAdvance\DbAdvance.Host.exe"

        $serverName = "(local)"
        $databaseName = "AdventureWorks2008"
        $connectionString = "Data Source=" + $serverName + ";Integrated Security=SSPI;"
        
        $outputPath = "z:\Moloch\Work\Projects\db-keeper\temp\MsDbProjSvn\"
        
        Export-ModuleMember -Variable * -Function *
    } -asCustomObject  
}