Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force;
Install-Module DockerMsftProvider -Force;
Install-Package -Name docker -ProviderName DockerMsftProvider -Force -RequiredVersion ${ee_version};

$scriptlocation = "c:\join_ucp.ps1"

schtasks.exe /create /f /tn HeadlessRestartTask /ru SYSTEM /sc ONSTART /tr "powershell.exe -file $scriptlocation"
Write-Host "`"$scriptlocation`" is scheduled to run once after reboot."

Restart-Computer -Force;
