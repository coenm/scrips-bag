# Include library (function) to update .NET configuration file.
. .\DotNetConfigurationFileUpdateLib.ps1

 
$replacement = @{
    "base_dir_storage"                  = "C:\tmp\storage"; 
    "connect_to_ip"                     = "10.11.12.13";
    "connect_to_port"                   = "8080";
}
$success = Update-DotNet-Config-File "${config_filename}" $replacement 
if ( $success -ne $true )
{
    Write-Host "[!] ERROR: Could not update .net config file. Exit"
    Exit 1013;
}
Write-Host "[*] Done"
