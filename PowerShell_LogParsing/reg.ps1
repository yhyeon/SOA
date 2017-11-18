$sw = [System.Diagnostics.Stopwatch]::startnew()
$ErrorActionPreference = 'silentlycontinue'
if(!(test-path 'C:\ProgramData\soalog'))
{new-item -Path "C:\ProgramData\soalog" -ItemType Directory -Force }
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

$usbpath = 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\enum\usb\*\*', 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\enum\usbstor\*\*'
$reg = get-childitem $usbpath
foreach($usb in $reg)
{
$devicedesc = ($usb | ForEach-Object {Get-ItemProperty $_.pspath} | select devicedesc).devicedesc
$hardwareid = ($usb | ForEach-Object {Get-ItemProperty $_.pspath} | select hardwareid).hardwareid[0]
$compatibleids = ($usb | ForEach-Object {Get-ItemProperty $_.pspath} | select compatibleids).compatibleids[0]
$driver = ($usb | ForEach-Object {Get-ItemProperty $_.pspath} | select driver).driver
$mfg = ($usb | ForEach-Object {Get-ItemProperty $_.pspath} | select mfg).mfg
$service = ($usb | ForEach-Object {Get-ItemProperty $_.pspath} | select service).service
$friendlyname = ($usb | ForEach-Object {Get-ItemProperty $_.pspath} | select friendlyname).friendlyname
$label = ($usb | ForEach-Object {Get-ItemProperty $_.pspath} | select label).label
$lifetiemid = ($usb | ForEach-Object {Get-ItemProperty $_.pspath} | select lifetimeid).lifetimeid


if (! (Test-Path -Path 'C:\ProgramData\soalog\r.txt'))
{
$sn + ":::;" + $ip + ":::;" + $mac + ":::;" + $devicedesc + ":::;" + $hardwareid + ":::;" + $compatibleids + ":::;" + $driver + ":::;" + $mfg + ":::;" + $service + ":::;" + $friendlyname + ":::;" | Out-File  C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_reg.txt -Append -Encoding utf8
}

else
{
$compare = Get-Content -Path 'C:\ProgramData\soalog\r.txt'
$sn + ":::;" + $ip + ":::;" + $mac + ":::;" + $devicedesc + ":::;" + $hardwareid + ":::;" + $compatibleids + ":::;" + $driver + ":::;" + $mfg + ":::;" + $service + ":::;" + $friendlyname + ":::;" | Where-Object {$_ -notin $compare} | Out-File  C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_reg.txt -Append -Encoding utf8
$compare.Dispose()
}
$devicedesc.Dispose()
$hardwareid.Dispose()
$compatibleids.Dispose()
$driver.Dispose()
$mfg.Dispose()
$service.Dispose()
$friendlyname.Dispose()
$label.Dispose()
$lifetiemid.Dispose()
$usb.Dispose()
}
$reg.Dispose()
$usbpath.Dispose()


Import-Module bitstransfer
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
#$src = "C:\ProgramData\soalog\" # directory in which files to be sent
$src = "C:\ProgramData\soalog\*_reg.txt"
Get-ChildItem -path $src |
foreach {
if ($_.Length -eq "0")
{
Remove-Item $($_.FullName)
}
$dst = "http://cdisc.co.kr:1024/soa/upload/$($_.name)" # server directory with write permissions
$job = Start-BitsTransfer -source $($_.FullName) -Destination $dst -Credential $cred -TransferType Upload -Asynchronous

while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 10;}
if ($job.JobState -eq "Transferred")
{
Get-Content $($_.FullName) | out-file C:\ProgramData\soalog\r.txt -Append -Encoding utf8
Remove-Item $($_.FullName)
}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
"TransientError" {Resume-BitsTransfer -BitsJob $job}
"Error" {Resume-BitsTransfer -BitsJob $job}
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