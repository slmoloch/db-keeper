function create-config
{
    @{
        svn_tool = "z:\Tools\SlikSvn\bin\svn.exe" 
        svn_solution_url = "https://db-keeper.googlecode.com/svn/trunk/SampleDatabases/MicrosoftDatabaseProject"

        #fakepath = "z:\Moloch\Work\Projects\database-fake-2\"
               
        msbuild_tool = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"
        vsdb_tool = "C:\Program Files\Microsoft Visual Studio 10.0\VSTSDB\Deploy\vsdbcmd.exe"
        sqlcmd_tool = "c:\Program Files\Microsoft SQL Server\100\Tools\Binn\SQLCMD.EXE"
        tablediff_tool = "C:\Program Files\Microsoft SQL Server\100\COM\tablediff.exe"
        ocdb_tool = "z:\Tools\OpenDbDiff\OCDB.exe"
        dbadvance_tool = "z:\Tools\DbAdvance\DbAdvance.Host.exe"

        serverName = "(local)"
        connectionString = "Data Source=(local);Integrated Security=SSPI;"
        databaseName = "AdventureWorks2008"
        
        outputPath = "z:\db-keeper\temp\MsDbProjSvn\"
    }
}