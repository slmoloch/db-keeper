function new-slices-package
{
    param($filesystem, $slicesPath)
    
    New-Module {
        param($filesystem, $slicesPath)
        
        function Root
        {
            $slicesPath
        }
        
        function MigrationsPath
        {
            join-path (& Root) "Migrations"
        }
        
        function GetMigrationScriptNames
        {
            get-childItem (& MigrationsPath) | %{ $_.Name }
        }
        
        function Init
        {
            $filesystem.Recreate($slicesPath)
            
            new-item (& MigrationsPath) -type directory | out-null
        }
        
        function CopyToMigrations
        {
            param($files)
            
            $files | % { copy-item $_.FullName (& MigrationsPath) }
        }
        
        Export-ModuleMember -Function *                
    } -ArgumentList ($filesystem, $slicesPath) -asCustomObject  
}