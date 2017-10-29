$ErrorActionPreference = 'silentlycontinue'
$osversion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName).ProductName
if($osversion -match "Windows 7") # if the Client is Windows 7
{
#mac, ip 받아오는 부분 추가 필요
$events = get-winevent -FilterHashtable @{logname = 'Microsoft-Windows-DriverFrameworks-UserMode/Operational'; ID = 1003, 1008} | foreach {$_.toxml()}
foreach ($driver in $events)
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
$datetime = get-date $datetime -format yyyy-MM-dd@HH:mm:ss
$date = $datetime.split("@")[0]
$time = $datetime.Split("@")[1]
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
$ip + ":::;" + $mac + ":::;" + $computer + ":::;" + $sid + ":::;" + $date + ":::;" + $time + ":::;" + $eventid + ":::;" + $slifetime + ":::;" + $hostguid + ":::;" + $device + ":::;" + 'USB 연결' | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_Win7Driver.txt -Append -Encoding utf8
}
else
{
$datetime = $driver | select-string -pattern 'TimeCreated' | Out-String
$datetime = $datetime.split("=")[1]
$datetime = [datetime]($datetime.split("'")[1])
$datetime = get-date $datetime -format yyyy-MM-dd@HH:mm:ss
$date = $datetime.split("@")[0]
$time = $datetime.Split("@")[1]
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
$ip + ":::;" + $mac + ":::;" + $computer + ":::;" + $sid + ":::;" + $date + ":::;" + $time + ":::;" + $eventid + ":::;" + $elifetime + ":::;" + ":::;" + ":::;" + 'USB 해제' | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_Win7Driver.txt -Append -Encoding utf8
}
}
}
elseif ($osversion -match "Windows 10") # if the client is Windows 10
{
$IP = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.netadapter.status -ne "Disconnected"}).ipv4address.ipaddress
$MAC = (Get-NetAdapter | where-object -FilterScript {$_.HardwareInterface -eq "True" -and $_.Status -ne "Disconnected"}).MacAddress
$events = get-winevent -FilterHashtable @{logname = 'Microsoft-Windows-Partition/Diagnostic'} | foreach {$_.toxml()}
foreach ($partition in $events)
{
$partition = $partition.split("<")
$eventrecordid = $partition | select-string -pattern 'EventRecordID>'
$eventrecordid = $eventrecordid.line.trim("/*")
$eventid = $partition | select-string -pattern 'EventID'
$eventid = $eventid.line.split(">")[1]
$datetime = $partition | select-string -pattern 'TimeCreated'
$datetime = [datetime]($datetime.line.split("=").split("/>").split("'")[2])
$datetime = get-date $datetime -format yyyy-MM-dd@HH:mm:ss
$date = $datetime.Split("@")[0]
$time = $datetime.Split("@")[1]
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
$ip + ":::;" + $mac + ":::;" + $computer + ":::;" + $sid + ":::;" + $date + ":::;" + $time + ":::;" + $eventid + ":::;" + $disknumber + ":::;" + $diskid + ":::;" + $characteristics + ":::;" + $busType + ":::;" + $manufacturer + ":::;" + $model + ":::;" + $revision + ":::;" + $serialnumber + ":::;" + $parentid + ":::;" + $registryid | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_partition.txt -Append -Encoding utf8
}
}
