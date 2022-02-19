$ProgressPreference = "SilentlyContinue"
# https://docs.microsoft.com/en-us/powershell/module/packagemanagement/get-packageprovider?view=powershell-7.2
#TLS Setting
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Wow6432Node\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord
Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\.NetFramework\v4.0.30319' -Name 'SchUseStrongCrypto' -Value '1' -Type DWord

# set-executionpolicy bypass -scope process -force

#Install NuGet
Get-PackageProvider NuGet -ForceBootstrap -Force | Out-Null
#Trust PowerShell Gallery - this will avoid you getting any prompts that it's untrusted
Set-PSRepository -Name 'PSGallery' -InstallationPolicy Trusted

# Install-PackageProvider -name NuGet -Force | Out-Null

#Install Module
# Install PSWindowsUpdate Installation Framework
$ModuleLoaded = Get-Module -Name PSWindowsUpdate -ListAvailable
If ($null -eq $ModuleLoaded) {
	Import-PackageProvider -Name NuGet -Force
	Install-Module PSWindowsUpdate -Force -AllowClobber | Out-Null
}
# Install-Module PSWindowsUpdate -Force 
Import-Module -Name PSWindowsUpdate -DisableNameChecking -Force -Global

#Check what updates are required for this server
# Get-WindowsUpdate

If (!(Test-Path C:\Assets)){ New-Item -ItemType Directory -Path C:\Assets | Out-Null } 

#Accept and install all the updates that it's found are required
Install-WindowsUpdate -AcceptAll -Install -MicrosoftUpdate -IgnoreReboot -RecurseCycle 2 -NotCategory "Drivers" | Out-File "C:\Assets\$env:Computername-$(Get-Date -f yyyy-MM-dd)-MSUpdates.log" -Force
Start-Process -NoNewWindow "c:\windows\system32\UsoClient.exe" -argument "StartOobeAppsScan" -Wait
