<# 
.SYNOPSIS 
Update .NET application configuration file  
 
.DESCRIPTION 
 The xxx.config file contains an app-settings entry like '<add key="xxxx" value="yyy"/>'. This script will update this value to point to a new generated file containing with new configuration.  

.PARAMETER config_filename 
Filename (from working_directory) to the x.config file containing the C# configuration with the appsettings section.
This file will be updated.  

.PARAMETER replacement_hash_table 
Hashtable containing all elements to be replaced. 

.EXAMPLE 
Update the 'host_ip' app setting to value '10.11.12.13'
Update-DotNet-Config-File ".\MyConsoleApplication.exe.config" @{"host_ip" = "10.11.12.13";}

.EXAMPLE 
Update the 'host_ip' app setting to value '10.11.12.13' and upate 'host_port' to '8081'
Update-DotNet-Config-File "C:\MyConsoleApplication.exe.config" @{"host_ip" = "10.11.12.13"; "host_port" = "8081";}

.NOTES 
- Script does NOT check if config_filename exists, and have write rights.
#>
function Update-DotNet-Config-File([string]$config_filename, $replacement_hash_table)
{
    # Start updating configuration files.
    Write-Host "Read content config_file '${config_filename}'."
	Try
	{
		# $AuthorizedUsers= Get-Content \\ FileServer\HRShare\UserList.txt -ErrorAction Stop
		$content = [IO.File]::ReadAllText("${config_filename}")

		# Regex matches '<add key="xxxxxx" value="yyyyy"/> \n' 
		$regex = '[$|\n][\s\t]*\<add\s+key="([^"]+)"[\s\t]+value="([^"]*)"[\s\t]*/>[\s\t]*\r?[\n|$]'

		[regex]::Matches($content, $regex) |  
		Foreach-Object   `
		{ `
			# if there are matches, group[0] contains the whole string, group[1] contains the key, group[2] contains the value to replace.
			
			$key = $_.groups[1].Value
			$origValue = $_.groups[2].Value

			Write-Host "Found key '${key}' with value '${origValue}'"

			If ( $replacement_hash_table.ContainsKey($key) )
			{
				$replacementValue = $replacement_hash_table[$key]
				
				Write-Host "Key '${key}' exists in hash table. Value '${origValue}' will be replaced with '${replacementValue}'"

				$origFullMatch = $_.groups[0].Value;

				$origValue2 = "value=""${origValue}"""
				$replacementValue2 = "value=""${replacementValue}"""
				$updatedFullMatch = $origFullMatch.replace($origValue2, $replacementValue2);
				$content = $content.replace($origFullMatch, $updatedFullMatch);
			}
		}

		$content.Trim() | Set-Content "${config_filename}"
	}
	Catch
	{
		$ErrorMessage = $_.Exception.Message
		Write-Host "Could not update .NET config file. Error message: $ErrorMessage"
		return $false;
	}
	return $true;
}