function create-config
{
    New-Module {
        $fakepath = "z:\Moloch\Work\Projects\database-fake\"

        $msbuild_tool = "C:\Windows\Microsoft.NET\Framework\v4.0.30319\MSBuild.exe"
        $vsdb_tool = "C:\Program Files\Microsoft Visual Studio 10.0\VSTSDB\Deploy\vsdbcmd.exe"
        $sqlcmd_tool = "c:\Program Files\Microsoft SQL Server\100\Tools\Binn\SQLCMD.EXE"
        $tablediff_tool = "C:\Program Files\Microsoft SQL Server\100\COM\tablediff.exe"
        $ocdb_tool = "z:\Tools\OpenDbDiff\OCDB.exe"
        $dbadvance_tool = "z:\Tools\DbAdvance\DbAdvance.Host.exe"

        $serverName = "(local)"
        $databaseName = "TestDatabase"
        $connectionString = "Data Source=" + $serverName + ";Integrated Security=SSPI;"
        
        $outputPath = "z:\Moloch\Work\Projects\db-keeper\temp\MsDbProj\"
        
        Export-ModuleMember -Variable * -Function *
    } -asCustomObject  
}