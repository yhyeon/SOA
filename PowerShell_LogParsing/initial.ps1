if (!(Test-Path "C:\Windows\soa\enp.txt"))
{ new-item -Path "C:\Windows\soa" -ItemType Directory -Force 
Start-BitsTransfer -source http://cdisc.co.kr:1024/soa/download/pass.txt -Destination C:\Windows\soa\pass.txt
get-content C:\Windows\soa\pass.txt | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString | out-file "C:\Windows\soa\enp.txt"
Remove-Item C:\Windows\soa\pass.txt }

if (!((Get-WmiObject -Class win32_useraccount) | Where-Object {$_.name -Match "soa"}))
{
$pass = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString
New-LocalUser -name "soa" -password $pass -PasswordNeverExpires -AccountNeverExpires -UserMayNotChangePassword
Add-LocalGroupMember -Group "Administrators" -Member "soa"
$pass.Dispose()
}



$osversion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName).ProductName
if(($osversion -match "Windows 7"))
{
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
Remove-Item C:\temp\msu -recurse -force
}


if (!(test-path 'HKLM:\SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full'))
{
(new-object net.webclient).downloadfile("http://cdisc.co.kr:1024/soa/download/dotNetFx45_Full_setup.exe", "C:\Windows\soa\ps5\dotNetFx45_Full_setup.exe")
start-process -filepath "C:\Windows\soa\ps5\dotNetFx45_Full_setup.exe" -Argumentlist "/q /norestart" -wait
Restart-Computer -Force
}

if (($PSVersionTable).PSVersion -match "4.*")
{

Start-BitsTransfer -source http://cdisc.co.kr:1024/soa/download/Win7AndW2K8R2-KB3191566-x64.zip -Destination C:\Windows\soa\ps5\Win7AndW2K8R2-KB3191566-x64.zip -TransferType Download

Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory("C:\Windows\soa\ps5\Win7AndW2K8R2-KB3191566-x64.zip", "C:\Windows\soa\ps5\")
Start-Process -wait -FilePath "C:\Windows\soa\ps5\Win7AndW2K8R2-KB3191566-x64.msu" -ArgumentList "/quiet"
powershell.exe -ExecutionPolicy Bypass -Command "C:\Windows\soa\ps5\Install-WMF5.1.ps1 -AcceptEula"
Restart-Computer -Force
}

Remove-Item C:\Windows\soa\ps5 -recurse -force

#Set-Item WsMan:\Localhost\Shell\MaxMemoryPerShellMB 2048

#Set-Item WsMan:\localhost\Plugin\microsoft.powershell\Quotas\MaxConcurrentCommandsPerShell 2048

#Set-Item WsMan:\localhost\Plugin\microsoft.powershell\Quotas\MaxMemoryPerShellMB 2048

#Restart-Service winrm

#Limit-Eventlog -LogName "Security" -MaximumSize 20MB -OverflowAction DoNotOverwrite -RetentionDays 14
auditpol /set /subcategory:"로그온","로그오프","파일 시스템" /success:enable /failure:enable
auditpol /resourceSACL /set /type:File /user:everyone /success /failure

$LogName = "Security"
mkdir C:\ProgramData\soalog\EventLogs
mkdir C:\ProgramData\soalog\EventLogs\$LogName
New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\$LogName" -Name "AutoBackupLogFiles" -Value "1" -PropertyType "DWord"
New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\$LogName" -Name "Flags" -Value "1" -PropertyType "DWord"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\$LogName" -Name "File" -Value "F:\EventLogs\$LogName\$LogName.evtx"

$LogName.Dispose()

$env:COMPUTERNAME | out-file C:\ProgramData\soalog\$env:COMPUTERNAME_ComputerName.txt -Append -Encoding utf8

$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = 'C:\ProgramData\soalog\*ComputerName.txt'
Get-ChildItem -path $src |
foreach {
$dst = "http://cdisc.co.kr:1024/soa/upload/$($_.name)" # server directory with write permissions
$job = Start-BitsTransfer -source $($_.FullName) -Destination $dst -Credential $cred -TransferType Upload -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 20;}
if ($job.JobState -eq "Transferred")
{
Remove-Item $($_.FullName)
}

Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
#"TransientError" {Resume-BitsTransfer -BitsJob $job}
#"Error" {Resume-BitsTransfer -BitsJob $job}
}
$dst.Dispose()
$job.Dispose()
}
$enc.Dispose()
$user.Dispose()
$cred.Dispose()
$src.Dispose()

Start-BitsTransfer -source http://cdisc.co.kr:1024/soa/download/ts.ps1 -Destination C:\Windows\soa\ts.ps1 -TransferType Download

powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\ts.ps1' -verb RunAs}"

sleep 60
powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\clips.ps1' -verb RunAs}"

sleep 10
powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\dscan.ps1' -verb RunAs}"

sleep 10
powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\part.ps1' -verb RunAs}"

sleep 10
powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\filter.ps1' -verb RunAs}"

sleep 10
powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\bsud.ps1' -verb RunAs}"

sleep 10
powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\bsud_rt.ps1' -verb RunAs}"

sleep 10
powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\reg.ps1' -verb RunAs}"

sleep 10
powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\sec.ps1' -verb RunAs}"
}



elseif(($osversion -match "Windows 8"))
{

if(!(Get-WmiObject -Class Win32_QuickFixEngineering -property hotfixid | Where {$_.hotfixid -match "KB3191564"}))
{
if (!(Test-Path "C:\Windows\soa\ps5\"))
{new-item -Path "C:\Windows\soa\ps5" -ItemType Directory -Force}
Start-BitsTransfer -source http://cdisc.co.kr:1024/soa/download/Win8.1AndW2K12R2-KB3191564-x64.msu -Destination C:\Windows\soa\ps5\Win8.1AndW2K12R2-KB3191564-x64.msu -TransferType Download
Start-Process -FilePath "C:\Windows\soa\Win8.1AndW2K12R2-KB3191564-x64.msu" -ArgumentList "/quiet"
Restart-Computer -force
}

$driverlog = get-winevent -listlog Microsoft-Windows-DriverFrameworks-UserMode/Operational
$driverlog.isenabled = $true
$driverlog.SaveChanges()

#Set-Item WsMan:\Localhost\Shell\MaxMemoryPerShellMB 2048

#Set-Item WsMan:\localhost\Plugin\microsoft.powershell\Quotas\MaxConcurrentCommandsPerShell 2048

#Set-Item WsMan:\localhost\Plugin\microsoft.powershell\Quotas\MaxMemoryPerShellMB 2048

#Restart-Service winrm

#Limit-Eventlog -LogName "Security" -MaximumSize 20MB -OverflowAction DoNotOverwrite -RetentionDays 14
auditpol /set /subcategory:"로그온","로그오프","파일 시스템","이동식 저장소" /success:enable /failure:enable
auditpol /resourceSACL /set /type:File /user:everyone /success /failure

$LogName = "Security"
mkdir C:\ProgramData\soalog\EventLogs
mkdir C:\ProgramData\soalog\EventLogs\$LogName
New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\$LogName" -Name "AutoBackupLogFiles" -Value "1" -PropertyType "DWord"
New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\$LogName" -Name "Flags" -Value "1" -PropertyType "DWord"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\$LogName" -Name "File" -Value "F:\EventLogs\$LogName\$LogName.evtx"

$LogName.Dispose()

$env:COMPUTERNAME | out-file C:\ProgramData\soalog\$env:COMPUTERNAME_ComputerName.txt -Append -Encoding utf8

$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = 'C:\ProgramData\soalog\*ComputerName.txt'
Get-ChildItem -path $src |
foreach {
$dst = "http://cdisc.co.kr:1024/soa/upload/$($_.name)" # server directory with write permissions
$job = Start-BitsTransfer -source $($_.FullName) -Destination $dst -Credential $cred -TransferType Upload -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 20;}
if ($job.JobState -eq "Transferred")
{
Remove-Item $($_.FullName)
}

Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
#"TransientError" {Resume-BitsTransfer -BitsJob $job}
#"Error" {Resume-BitsTransfer -BitsJob $job}
}
$dst.Dispose()
$job.Dispose()
}
$enc.Dispose()
$user.Dispose()
$cred.Dispose()
$src.Dispose()

$driverlog.Dispose()

Start-BitsTransfer -source http://cdisc.co.kr:1024/soa/download/ts.ps1 -Destination C:\Windows\soa\ts.ps1 -TransferType Download

powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\ts.ps1' -verb RunAs}"

sleep 60
powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\clips.ps1' -verb RunAs}"

sleep 10
powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\dscan.ps1' -verb RunAs}"

sleep 10
powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\part.ps1' -verb RunAs}"

sleep 10
powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\filter.ps1' -verb RunAs}"

sleep 10
powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\bsud.ps1' -verb RunAs}"

sleep 10
powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\bsud_rt.ps1' -verb RunAs}"

sleep 10
powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\reg.ps1' -verb RunAs}"

sleep 10
powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\sec.ps1' -verb RunAs}"
}


elseif(($osversion -match "Windows 10"))
{
#Limit-Eventlog -LogName "Security" -MaximumSize 20MB -OverflowAction DoNotOverwrite -RetentionDays 14
auditpol /set /subcategory:"로그온","로그오프","파일 시스템","이동식 저장소" /success:enable /failure:enable
auditpol /resourceSACL /set /type:File /user:everyone /success /failure

$LogName = "Security"
mkdir C:\ProgramData\soalog\EventLogs
mkdir C:\ProgramData\soalog\EventLogs\$LogName
New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\$LogName" -Name "AutoBackupLogFiles" -Value "1" -PropertyType "DWord"
New-ItemProperty "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\$LogName" -Name "Flags" -Value "1" -PropertyType "DWord"
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\EventLog\$LogName" -Name "File" -Value "F:\EventLogs\$LogName\$LogName.evtx"

$LogName.Dispose()

$env:COMPUTERNAME | out-file C:\ProgramData\soalog\$env:COMPUTERNAME_ComputerName.txt -Append -Encoding utf8

$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = 'C:\ProgramData\soalog\*ComputerName.txt'
Get-ChildItem -path $src |
foreach {
$dst = "http://cdisc.co.kr:1024/soa/upload/$($_.name)" # server directory with write permissions
$job = Start-BitsTransfer -source $($_.FullName) -Destination $dst -Credential $cred -TransferType Upload -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 20;}
if ($job.JobState -eq "Transferred")
{
Remove-Item $($_.FullName)
}

Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
#"TransientError" {Resume-BitsTransfer -BitsJob $job}
#"Error" {Resume-BitsTransfer -BitsJob $job}
}
$dst.Dispose()
$job.Dispose()
}
$enc.Dispose()
$user.Dispose()
$cred.Dispose()
$src.Dispose()

#Set-Item WsMan:\Localhost\Shell\MaxMemoryPerShellMB 2048

#Set-Item WsMan:\localhost\Plugin\microsoft.powershell\Quotas\MaxConcurrentCommandsPerShell 2048

#Set-Item WsMan:\localhost\Plugin\microsoft.powershell\Quotas\MaxMemoryPerShellMB 2048

#Restart-Service winrm

Start-BitsTransfer -source http://cdisc.co.kr:1024/soa/download/ts.ps1 -Destination C:\Windows\soa\ts.ps1 -TransferType Download

powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\ts.ps1' -verb RunAs}"

sleep 60
powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\clips.ps1' -verb RunAs}"

sleep 10
powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\dscan.ps1' -verb RunAs}"

sleep 10
powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\part.ps1' -verb RunAs}"

sleep 10
powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\filter.ps1' -verb RunAs}"

sleep 10
powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\bsud.ps1' -verb RunAs}"

sleep 10
powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\bsud_rt.ps1' -verb RunAs}"

sleep 10
powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\reg.ps1' -verb RunAs}"

sleep 10
powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\sec.ps1' -verb RunAs}"
}



$osversion.Dispose()
