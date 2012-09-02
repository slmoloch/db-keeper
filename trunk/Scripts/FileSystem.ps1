function create-filesystem
{
    New-Module {
        function Recreate
        {
            param ([string] $path)
            
            if (test-path $path) 
            { 
                remove-item $path -recurse -force | out-null
            }     

            new-item $path -type directory | out-null
        }
        
        Export-ModuleMember -Variable * -Function *                
    } -asCustomObject  
}