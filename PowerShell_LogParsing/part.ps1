$ErrorActionPreference = 'silentlycontinue'
if(!(test-path 'C:\ProgramData\soalog'))
{new-item -Path "C:\Windows\soa" -ItemType Directory -Force }
$osversion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName).ProductName
if(($osversion -match "Windows 7") -or ($osversion -match "windows 8")) # if the Client is Windows 7 or Windows 8
{
$driverlog = get-winevent -listlog Microsoft-Windows-DriverFrameworks-UserMode/Operational
$driverlog.isenabled = $true
$driverlog.SaveChanges()
$driverlog.Dispose()
$IP = (Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter 'IPEnabled = True' | select IPAddress).IPAddress[0]
$MAC = ((Get-WmiObject -Class Win32_NetworkAdapterConfiguration -Filter 'IPEnabled = True' | select MACAddress).MACAddress).replace(":","-")
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

$driverlog = get-winevent -FilterHashtable @{logname = 'Microsoft-Windows-DriverFrameworks-UserMode/Operational'; ID = 1003, 1008} | foreach {$_.toxml()}
#foreach ($driver in (get-winevent -FilterHashtable @{logname = 'Microsoft-Windows-DriverFrameworks-UserMode/Operational'; ID = 1003, 1008} | foreach {$_.toxml()}))

foreach ($driver in $driverlog)
{
$driver = $driver.split("<")
$eventid = $driver | select-string -pattern 'EventID' | out-string
$eventid = $eventid.split(">")[1]
$eventid = $eventid.split("
")[0]
if($eventid -eq 1003)
{
$datetime = $driver | select-string -pattern 'TimeCreated' | Out-String
$datetime = $datetime.split("=")[1]
$datetime = [datetime]($datetime.split("'")[1])
$datetime = get-date $datetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$date = $datetime.split("@")[0]
#$time = $datetime.Split("@")[1]
$computer = $driver | select-string -pattern 'Computer' | Out-String
$computer = $computer.split(">")[1]
$computer = $computer.split("/")[0]
$computer = $computer.split("
")[0]
$sid = $driver | select-string -pattern 'Security UserID' | out-string
$sid = $sid.split("=")[1]
$sid = $sid.split("'")[1]
$slifetime = $driver | select-string -pattern 'UMDFDriverManagerHostCreateStart lifetime' | out-string
$slifetime = $slifetime.split("{")[1]
$slifetime = $slifetime.Split("}")[0]
$hostguid = $driver | select-string -pattern 'Hostguid' | out-string
$hostguid = $hostguid.split("{")[1]
$hostguid = $hostguid.Split("}")[0]
$device = $driver | select-string -pattern 'DeviceInstanceId' | Out-String
$device = $device.split(">")[1]
$device = $device.split("
")[0]

if (!(Test-Path C:\ProgramData\soalog\d.txt))
{
$sn + ":::;" + $ip + ":::;" + $mac + ":::;" + $computer + ":::;" + $sid + ":::;" + $datetime + ":::;" + $eventid + ":::;" + $slifetime + ":::;" + $hostguid + ":::;" + $device + ":::;" + 'USB 연결' + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_Win7Driver.txt -Append -Encoding utf8
}
else
{
$compare = Get-Content -Path 'C:\ProgramData\soalog\d.txt'
$sn + ":::;" + $ip + ":::;" + $mac + ":::;" + $computer + ":::;" + $sid + ":::;" + $datetime + ":::;" + $eventid + ":::;" + $slifetime + ":::;" + $hostguid + ":::;" + $device + ":::;" + 'USB 연결' + ":::;" | Where-Object {$_ -notin $compare} | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_Win7Driver.txt -Append -Encoding utf8
$compare.Dispose()
}
$datetime.Dispose()
$computer.Dispose()
$sid.Dispose()
$slifetime.Dispose()
$hostguid.Dispose()
$device.Dispose()
$driver.Dispose()
}


else
{
$datetime = $driver | select-string -pattern 'TimeCreated' | Out-String
$datetime = $datetime.split("=")[1]
$datetime = [datetime]($datetime.split("'")[1])
$datetime = get-date $datetime -format yyyy-MM-ddTHH:mm:ss+09:00
$computer = $driver | select-string -pattern 'Computer' | Out-String
$computer = $computer.split(">")[1]
$computer = $computer.split("/")[0]
$computer = $computer.split("
")[0]
$sid = $driver | select-string -pattern 'Security UserID' | out-string
$sid = $sid.split("=")[1]
$sid = $sid.split("'")[1]
$elifetime = $driver | select-string -pattern 'UMDFDriverManagerHostShutdown lifetime' | out-string
$elifetime = $elifetime.split("{")[1]
$elifetime = $elifetime.Split("}")[0]


if (!(Test-Path C:\ProgramData\soalog\d.txt))
{
$sn + ":::;" + $ip + ":::;" + $mac + ":::;" + $computer + ":::;" + $sid + ":::;" + $datetime + ":::;" + $eventid + ":::;" + $elifetime + ":::;" + ":::;" + ":::;" + 'USB 해제' + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_Win7Driver.txt -Append -Encoding utf8
}
else
{
$compare = Get-Content -Path 'C:\ProgramData\soalog\d.txt'
$sn + ":::;" + $ip + ":::;" + $mac + ":::;" + $computer + ":::;" + $sid + ":::;" + $datetime + ":::;" + $eventid + ":::;" + $elifetime + ":::;" + ":::;" + ":::;" + 'USB 해제' + ":::;" | Where-Object {$_ -notin $compare} | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_Win7Driver.txt -Append -Encoding utf8
$compare.Dispose()
}
$elifetime.Dispose()
$sid.Dispose()
$computer.Dispose()
$datetime.Dispose()
}
$driver.Dispose()
}
$driverlog.Dispose()
$sn.Dispose()
$MAC.Dispose()
$IP.Dispose()
}

elseif ($osversion -match "Windows 10") # if the client is Windows 10
{
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


#Get-ChildItem -path "C:\Windows\System32\winevt\Logs\*Partition*" | copy-Item -Destination C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_Microsoft-Windows-Partition%4Diagnostic.evtx
#$events = get-winevent -path C:\ProgramData\soalog\*partition*.evtx | foreach {$_.toxml()}

$partitionlog = get-winevent -FilterHashtable @{logname = 'Microsoft-Windows-Partition/Diagnostic'} | foreach {$_.toxml()}
#foreach ($partition in (get-winevent -FilterHashtable @{logname = 'Microsoft-Windows-Partition/Diagnostic'} | foreach {$_.toxml()}))
foreach ($partition in $partitionlog)
{
$partition = $partition.split("<")
$eventrecordid = $partition | select-string -pattern 'EventRecordID>'
$eventrecordid = $eventrecordid.line.trim("/*")
$eventid = $partition | select-string -pattern 'EventID'
$eventid = $eventid.line.split(">")[1]
$datetime = $partition | select-string -pattern 'TimeCreated'
$datetime = [datetime]($datetime.line.split("=").split("/>").split("'")[2])
$datetime = get-date $datetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$date = [string]$datetime.Split("@")[0]
#$time = [string]$datetime.Split("@")[1]
$computer = $partition | select-string -pattern 'Computer'
$computer = $computer.line.split(">")[1]
$sid = $partition | select-string -pattern 'Security UserID'
$sid = $sid.line.split("=").split("/>").split("'")[2]
$disknumber = $partition | select-string -pattern 'DiskNumber'
$disknumber = $disknumber.line.Split("=").Split(">").Split("'")[4]
$characteristics = $partition | select-string -Pattern 'Characteristics'
$characteristics = $characteristics.Line.Split("=").Split(">").Split("'")[4]
$busType = $partition | Select-String -Pattern 'BusType'
$bustype = $busType.Line.Split("=").Split(">").Split("'")[4]
$manufacturer = $partition | select-string -pattern 'Manufacturer'
$manufacturer = $manufacturer.line.split("=").split(">").Split("'")[4]
$model = $partition | select-string -Pattern 'Model'
$model = $model.line.Split("=").Split(">").Split("'")[4]
$revision = $partition | select-string -pattern 'Revision'
$revision = $revision.Line.Split("=").Split(">").Split("'")[4]
$serialnumber = $partition | select-string -Pattern 'SerialNumber'
$serialnumber = $serialnumber.line.split("=").Split(">").Split("'")[4]
$parentid = $partition | select-string -Pattern 'ParentId'
$parentid = $parentid.line.split("=").split(">").split("'")[4]
$parentid = $parentid.replace("&amp;","&")
$diskid = $partition | select-string -Pattern 'DiskId'
$diskid = $diskid.line.Split("=").Split(">").Split("'").split("{").split("}")[5]
$registryid = $partition | select-string -Pattern 'RegistryId'
$registryid = $registryid.line.Split("=").Split(">").Split("'").split("{").split("}")[5]


if (! (Test-Path -Path 'C:\ProgramData\soalog\p.txt'))
{
$sn + ":::;" + $ip + ":::;" + $mac + ":::;" + $computer + ":::;" + $sid + ":::;" + $datetime + ":::;" + $eventid + ":::;" + $disknumber + ":::;" + $diskid + ":::;" + $characteristics + ":::;" + $busType + ":::;" + $manufacturer + ":::;" + $model + ":::;" + $revision + ":::;" + $serialnumber + ":::;" + $parentid + ":::;" + $registryid + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_partition.txt -Append -Encoding utf8
}
else
{
$compare = Get-Content -Path 'C:\ProgramData\soalog\p.txt'
$sn + ":::;" + $ip + ":::;" + $mac + ":::;" + $computer + ":::;" + $sid + ":::;" + $datetime + ":::;" + $eventid + ":::;" + $disknumber + ":::;" + $diskid + ":::;" + $characteristics + ":::;" + $busType + ":::;" + $manufacturer + ":::;" + $model + ":::;" + $revision + ":::;" + $serialnumber + ":::;" + $parentid + ":::;" + $registryid + ":::;" | Where-Object {$_ -notin $compare} | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_partition.txt -Append -Encoding utf8
$compare.Dispose()
}
$registryid.Dispose()
$diskid.Dispose()
$parentid.Dispose()
$serialnumber.Dispose()
$revision.Dispose()
$model.Dispose()
$manufacturer.Dispose()
$busType.Dispose()
$characteristics.Dispose()
$disknumber.Dispose()
$sid.Dispose()
$computer.Dispose()
$datetime.Dispose()
$eventid.Dispose()
$eventrecordid.Dispose()
$partition.Dispose()
}
$partitionlog.Dispose()
$sn.Dispose()
$MAC.Dispose()
$IP.Dispose()
}

Import-Module bitstransfer
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
#$src = "C:\ProgramData\soalog\" # directory in which files to be sent
$src = "C:\ProgramData\soalog\*_Win7Driver.txt", "C:\ProgramData\soalog\*partition.txt"
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
if ($($_.name) -match "Driver.txt")
{
get-content $($_.FullName) | Out-File "C:\ProgramData\soalog\d.txt" -Append -Encoding UTF8
}
if ($($_.name) -match "partition.txt")
{
get-content $($_.FullName) | Out-File "C:\ProgramData\soalog\p.txt" -Append -Encoding UTF8
Remove-Item $($_.FullName)
}
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


#Clear-Variable driver, eventid, partition, compare
$sw.stop()
$sw.Elapsed.tostring('dd\.hh\"mm\:ss\.fff')

