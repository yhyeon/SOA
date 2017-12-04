$ErrorActionPreference = 'silentlycontinue'

$sw = [System.Diagnostics.Stopwatch]::startnew()

if (!(Get-Module -name PowerForensics))
{
Install-Module -Name PowerForensics -Force
}

$IP = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.netadapter.status -ne "Disconnected"}).ipv4address.ipaddress
$MAC = (Get-NetAdapter | where-object -FilterScript {$_.HardwareInterface -eq "True" -and $_.Status -ne "Disconnected"} | Where-Object {$_.InterfaceDescription -notmatch "TEST"}).MacAddress
$sn = (Get-WMIObject win32_physicalmedia | Where-Object {$_.tag -match "PHYSICALDRIVE0"} | select SerialNumber).SerialNumber
if ($sn -ne $null)
{
if ($sn -match " ")
{
$sn = $sn.split(" ")[-1]
}
else
{
$sn = $sn
}
}
elseif ($sn -eq $null)
{
$sn = (Get-WMIObject win32_physicalmedia | Where-Object {$_.tag -match "PHYSICALDRIVE1"} | select SerialNumber).SerialNumber
if ($sn -match " ")
{
$sn = $sn.split(" ")[-1]
}
else
{
$sn = $sn
}
}


Import-Module PowerForensics
$uj = (Get-ForensicUsnJrnl -VolumeName C:)
$ujs = $uj | select volumepath, recordnumber, filesequencenumber, parentfilerecordnumber, parentfilesequencenumber, usn, timestamp, reason, filename, fileattributes
$count = $uj.Count

if (!(Test-Path -Path 'C:\ProgramData\soalog\uj.txt'))
{
for($i = 0; $i -lt $count; $i++)
{
$timestamp = $ujs[$i].timestamp | Get-Date -Format yyyy-MM-ddTHH:mm:ss+09:00
$sn + ":::;" + $env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + [string]($ujs[$i].VolumePath) + ":::;" + [string]($ujs[$i].RecordNumber)  + ":::;" + [string]($ujs[$i].FileSequenceNumber) + ":::;" + [string]($ujs[$i].ParentFileRecordNumber) + ":::;" + [string]($ujs[$i].ParentFileSequenceNumber) + ":::;" + [string]($ujs[$i].Usn) + ":::;" + $timestamp + ":::;" + [string]($ujs[$i].Reason) + ":::;" + [string]($ujs[$i].FileName) + ":::;" + [string]($ujs[$i].FileAttributes) | select -Unique | Out-File C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmm)_usnjrnl.txt -Append -Encoding utf8
$i.Dispose()
}
}

else
{
$compare = Get-Content -Path 'C:\ProgramData\soalog\uj.txt'
for($i = 0; $i -lt $count; $i++)
{
$timestamp = $ujs[$i].timestamp | Get-Date -Format yyyy-MM-ddTHH:mm:ss+09:00
$sn + ":::;" + $env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + [string]($ujs[$i].VolumePath) + ":::;" + [string]($ujs[$i].RecordNumber)  + ":::;" + [string]($ujs[$i].FileSequenceNumber) + ":::;" + [string]($ujs[$i].ParentFileRecordNumber) + ":::;" + [string]($ujs[$i].ParentFileSequenceNumber) + ":::;" + [string]($ujs[$i].Usn) + ":::;" + $timestamp + ":::;" + [string]($ujs[$i].Reason) + ":::;" + [string]($ujs[$i].FileName) + ":::;" + [string]($ujs[$i].FileAttributes) | Where-Object {$_ -notin $compare} | select -Unique | Out-File C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmm)_usnjrnl.txt -Append -Encoding utf8
$i.Dispose()
}
}

$count.Dispose()
$ujs.Dispose()
$uj.Dispose()


Import-Module bitstransfer
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "C:\ProgramData\soalog\*_usnjrnl.txt"
Get-ChildItem -path $src |
foreach {
$dst = "http://cdisc.co.kr:1024/soa/upload/$($_.name)" # server directory with write permissions
$job = Start-BitsTransfer -source $($_.FullName) -Destination $dst -Credential $cred -TransferType Upload -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 20;}
if ($job.JobState -eq "Transferred")
{
get-content $($_.FullName) | Out-File "C:\ProgramData\soalog\uj.txt" -Append -Encoding UTF8
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

$sw.stop()
$sw.Elapsed.tostring('dd\.hh\"mm\:ss\.fff')
