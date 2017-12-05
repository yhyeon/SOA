$ErrorActionPreference = 'silentlycontinue'

$sw = [System.Diagnostics.Stopwatch]::startnew()

<#
if (!(Get-Module -name PowerForensics))
{
Install-Module -Name PowerForensics -Force
}
#>

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
$rootdrive = (get-psdrive | where-object { $_.Provider.Name -eq "FileSystem" } | select root).root
foreach ($root in $rootdrive)
{
$r = $root.split("\")[0]
$mft = Get-ForensicFileRecord -VolumeName $r
$mfts = $mft | select FullName, Name, SequenceNumber, RecordNumber, ParentSequenceNumber, ParentRecordNumber, Directory, Deleted, ModifiedTime, AccessedTime, ChangedTime, BornTime, FNModifiedTime, FNAccessedTime, FNChangedTime, FNBornTime
$count = $mft.count

if (!(Test-Path -Path 'C:\ProgramData\soalog\mt.txt'))
{
for($i = 0; $i -lt $count; $i++)
{
$mtime = $mfts[$i].ModifiedTime | Get-Date -Format yyyy-MM-ddTHH:mm:ss+09:00
$atime = $mfts[$i].AccessedTime | Get-Date -Format yyyy-MM-ddTHH:mm:ss+09:00
$ctime = $mfts[$i].ChangedTime | Get-Date -Format yyyy-MM-ddTHH:mm:ss+09:00
$btime = $mfts[$i].BornTime | Get-Date -Format yyyy-MM-ddTHH:mm:ss+09:00

$fmtime = $mfts[$i].FNModifiedTime | Get-Date -Format yyyy-MM-ddTHH:mm:ss+09:00
$fatime = $mfts[$i].FNAccessedTime | Get-Date -Format yyyy-MM-ddTHH:mm:ss+09:00
$fctime = $mfts[$i].FNChangedTime | Get-Date -Format yyyy-MM-ddTHH:mm:ss+09:00
$fbtime = $mfts[$i].FNBornTime | Get-Date -Format yyyy-MM-ddTHH:mm:ss+09:00

$sn + ":::;" + $env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + [string]($mfts[$i].FullName) + ":::;" + [string]($mfts[$i].Name) + ":::;" + [string]($mfts[$i].SequenceNumber) + ":::;" + [string]($mfts[$i].RecordNumber) + ":::;" + [string]($mfts[$i].ParentSequenceNumber) + ":::;" + [string]($mfts[$i].ParentRecordNumber) + ":::;" + [string]($mfts[$i].Directory) + ":::;" + [string]($mfts[$i].Deleted) + ":::;" + $mtime + ":::;" + $atime + ":::;" + $ctime + ":::;" + $btime + ":::;" + $fmtime + ":::;" + $fatime + ":::;" + $fctime + ":::;" + $fbtime | select -Unique | Out-File C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmm)_mft.txt -Append -Encoding utf8

$i.Dispose()
$sn.Dispose()
$IP.Dispose()
$MAC.Dispose()
$mtime.Dispose()
$atime.Dispose()
$ctime.Dispose()
$btime.Dispose()
$fmtime.Dispose()
$fatime.Dispose()
$fctime.Dispose()
$fbtime.Dispose()
}
}


else
{
$compare = Get-Content -Path 'C:\ProgramData\soalog\mt.txt'
for($i = 0; $i -lt $count; $i++)
{
$mtime = $mfts[$i].ModifiedTime | Get-Date -Format yyyy-MM-ddTHH:mm:ss+09:00
$atime = $mfts[$i].AccessedTime | Get-Date -Format yyyy-MM-ddTHH:mm:ss+09:00
$ctime = $mfts[$i].ChangedTime | Get-Date -Format yyyy-MM-ddTHH:mm:ss+09:00
$btime = $mfts[$i].BornTime | Get-Date -Format yyyy-MM-ddTHH:mm:ss+09:00

$fmtime = $mfts[$i].FNModifiedTime | Get-Date -Format yyyy-MM-ddTHH:mm:ss+09:00
$fatime = $mfts[$i].FNAccessedTime | Get-Date -Format yyyy-MM-ddTHH:mm:ss+09:00
$fctime = $mfts[$i].FNChangedTime | Get-Date -Format yyyy-MM-ddTHH:mm:ss+09:00
$fbtime = $mfts[$i].FNBornTime | Get-Date -Format yyyy-MM-ddTHH:mm:ss+09:00

$sn + ":::;" + $env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + [string]($mfts[$i].FullName) + ":::;" + [string]($mfts[$i].Name) + ":::;" + [string]($mfts[$i].SequenceNumber) + ":::;" + [string]($mfts[$i].RecordNumber) + ":::;" + [string]($mfts[$i].ParentSequenceNumber) + ":::;" + [string]($mfts[$i].ParentRecordNumber) + ":::;" + [string]($mfts[$i].Directory) + ":::;" + [string]($mfts[$i].Deleted) + ":::;" + $mtime + ":::;" + $atime + ":::;" + $ctime + ":::;" + $btime + ":::;" + $fmtime + ":::;" + $fatime + ":::;" + $fctime + ":::;" + $fbtime | select -Unique | Where-Object {$_ -notin $compare} | Out-File C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmm)_mft.txt -Append -Encoding utf8

$i.Dispose()
$sn.Dispose()
$IP.Dispose()
$MAC.Dispose()
$mtime.Dispose()
$atime.Dispose()
$ctime.Dispose()
$btime.Dispose()
$fmtime.Dispose()
$fatime.Dispose()
$fctime.Dispose()
$fbtime.Dispose()
}
}



$r.dispose()
$root.dispose()
}
$rootdrive.dispose()

Import-Module bitstransfer
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "C:\ProgramData\soalog\*_mft.txt"
Get-ChildItem -path $src |
foreach {
$dst = "http://cdisc.co.kr:1024/soa/upload/$($_.name)" # server directory with write permissions
$job = Start-BitsTransfer -source $($_.FullName) -Destination $dst -Credential $cred -TransferType Upload -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 20;}
if ($job.JobState -eq "Transferred")
{
get-content $($_.FullName) | Out-File "C:\ProgramData\soalog\mt.txt" -Append -Encoding UTF8
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
