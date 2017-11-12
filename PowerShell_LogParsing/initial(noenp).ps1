Set-ItemProperty "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" -Name 'initial' -value "c:\WINDOWS\system32\WindowsPowerShell\v1.0\powershell.exe -ExecutionPolicy Bypass -windowstyle hidden -noexit -noprofile -file C:\Windows\client.ps1 -verb RunAs"

$osversion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName).ProductName
if(($osversion -match "Windows 7"))
{
#if(!(Get-WmiObject -Class Win32_QuickFixEngineering -property hotfixid -filter "HotFixID = 'KB2819745'"))
if(!(Get-WmiObject -Class Win32_QuickFixEngineering -property hotfixid | Where {($_.hotfixid -match "KB2819745") -or ($_.hotfixid -match "KB3191566")}))
{
if (!(Test-Path "C:\Windows\soa\ps5\"))
{new-item -Path "C:\Windows\soa\ps5" -ItemType Directory -Force}
(new-object net.webclient).downloadfile("http://cdisc.co.kr:1024/soa/download/Windows6.1-KB2819745-x64-MultiPkg.msu", "C:\Windows\soa\ps5\Windows6.1-KB2819745-x64-MultiPkg.msu")
if (!(Test-Path "C:\Temp\msu"))
{new-item -Path "C:\Temp\msu" -ItemType Directory -Force}
expand -f:* "C:\Windows\soa\ps5\Windows6.1-KB2819745-x64-MultiPkg.msu" C:\Temp\msu
dism.exe /online /add-package /packagepath:C:\Temp\msu\Windows6.1-KB2819745-x64.cab /norestart
dism.exe /online /add-package /packagepath:C:\Temp\msu\Windows6.1-KB2809215-x64.cab /norestart
dism.exe /online /add-package /packagepath:C:\Temp\msu\Windows6.1-KB2872035-x64.cab /norestart
#dism.exe /online /add-package /packagepath:C:\Temp\msu\Windows6.1-KB2872047-x64.cab /norestart
Remove-Item C:\temp\msu -recurse -force
}

if (!(Get-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full').Version -like '4.5*') # Install .NET Framework 4.5
{
(new-object net.webclient).downloadfile("http://cdisc.co.kr:1024/soa/download/dotNetFx45_Full_setup.exe", "C:\Windows\soa\ps5\dotNetFx45_Full_setup.exe")
start-process -filepath "C:\Windows\soa\ps5\dotNetFx45_Full_setup.exe" -Argumentlist "/q /norestart" -wait
#Restart-Computer -wait -timeout 60
Restart-Computer -Force
}

if (($PSVersionTable).PSVersion -match "4.*")
{

Start-BitsTransfer -source http://cdisc.co.kr:1024/soa/download/Win7AndW2K8R2-KB3191566-x64.zip -Destination C:\Windows\soa\ps5\Win7AndW2K8R2-KB3191566-x64.zip -TransferType Download

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory("C:\Windows\soa\ps5\Win7AndW2K8R2-KB3191566-x64.zip", "C:\Windows\soa\ps5\")
Start-Process -FilePath "C:\Windows\soa\Win7AndW2K8R2-KB3191566-x64.msu" -ArgumentList "/quiet" -wait
powershell.exe -ExecutionPolicy Bypass -Command "C:\Windows\soa\ps5\Install-WMF5.1.ps1 -AcceptEula -AllowRestart"

}

Remove-Item C:\Windows\soa\ps5 -recurse -force

auditpol /set /subcategory:"로그온","로그오프","파일 시스템" /success:enable /failure:enable
auditpol /resourceSACL /set /type:File /user:everyone /success /failure


}



elseif(($osversion -match "Windows 8"))
{

if(!(Get-WmiObject -Class Win32_QuickFixEngineering -property hotfixid | Where {$_.hotfixid -match "KB3191564"}))
{
if (!(Test-Path "C:\Windows\soa\ps5\"))
{new-item -Path "C:\Windows\soa\ps5" -ItemType Directory -Force}
Start-BitsTransfer -source http://cdisc.co.kr:1024/soa/download/Win8.1AndW2K12R2-KB3191564-x64.msu -Destination C:\Windows\soa\ps5\Win8.1AndW2K12R2-KB3191564-x64.msu -TransferType Download
Start-Process -FilePath "C:\Windows\soa\Win8.1AndW2K12R2-KB3191564-x64.msu" -ArgumentList "/quiet"
}

$driverlog = get-winevent -listlog Microsoft-Windows-DriverFrameworks-UserMode/Operational
$driverlog.isenabled = $true
$driverlog.SaveChanges()

auditpol /set /subcategory:"로그온","로그오프","파일 시스템","이동식 저장소" /success:enable /failure:enable
auditpol /resourceSACL /set /type:File /user:everyone /success /failure


}


elseif(($osversion -match "Windows 10"))
{
auditpol /set /subcategory:"로그온","로그오프","파일 시스템","이동식 저장소" /success:enable /failure:enable
auditpol /resourceSACL /set /type:File /user:everyone /success /failure

}




