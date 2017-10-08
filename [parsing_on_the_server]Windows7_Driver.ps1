$osversion = (Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name ProductName).ProductName
if($osversion -match "Windows 7") # if the Microsoft-Windows-DriverFrameworks-UserMode/Operational log is to be parsed on the client side
{
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
$datetime = get-date $datetime -format yyyy-MM-dd@hh:mm:ss
$date = $datetime.split("@")[0]
$time = $datetime.Split("@")[1]
$computer = $driver | select-string -pattern 'Computer' | Out-String
$computer = $computer.split(">")[1]
$computer = $computer.split("/")[0]
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
$computer + " : " + $sid + " : " + $date + " : " + $time + " : " + $eventid + " : " + $slifetime + " : " + $hostguid + " : " + $device + " : " + 'USB 연결' | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_Win7Driver.txt -Append -Encoding UTF8
}
else
{
$datetime = $driver | select-string -pattern 'TimeCreated' | Out-String
$datetime = $datetime.split("=")[1]
$datetime = [datetime]($datetime.split("'")[1])
$datetime = get-date $datetime -format yyyy-MM-dd@hh:mm:ss
$date = $datetime.split("@")[0]
$time = $datetime.Split("@")[1]
$computer = $driver | select-string -pattern 'Computer' | Out-String
$computer = $computer.split(">")[1]
$computer = $computer.split("/")[0]
$sid = $driver | select-string -pattern 'Security UserID' | out-string
$sid = $sid.split("=")[1]
$sid = $sid.split("'")[1]
$elifetime = $driver | select-string -pattern 'UMDFDriverManagerHostShutdown lifetime' | out-string
$elifetime = $elifetime.split("{")[1]
$elifetime = $elifetime.Split("}")[0]
$computer + " : " + $sid + " : " + $date + " : " + $time + " : " + $eventid + " : " + $elifetime + " : " + " : " + " : " + 'USB 해제' | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_Win7Driver.txt -Append -Encoding UTF8
}
}
}
else # if the client's log is to be sent to the server and parsed there
{
$events = get-winevent -FilterHashtable @{path = ''; ID = 1003, 1008} | foreach {$_.toxml()} #path should be designated correctly.
foreach ($driver in $events)
{
$driver = $driver.split("<")
$eventid = $driver | select-string -pattern 'EventID'
$eventid = $eventid.line.split(">")[1]
if($eventid -eq 1003)
{
$datetime = $driver | select-string -pattern 'TimeCreated'
$datetime = [datetime]($datetime.line.split("=").split("/>").split("'")[2])
$datetime = get-date $datetime -format yyyy-MM-dd@hh:mm:ss
$date = $datetime.Split("@")[0]
$time = $datetime.Split("@")[1]
$computer = $driver | select-string -pattern 'Computer'
$computer = $computer.line.split(">")[1]
$sid = $driver | select-string -pattern 'Security UserID'
$sid = $sid.line.split("=").split("/>").split("'")[2]
$slifetime = $driver | select-string -pattern 'UMDFDriverManagerHostCreateStart lifetime'
$slifetime = $slifetime.line.split("{").split("}")[1]
$hostguid = $driver | select-string -pattern 'Hostguid'
$hostguid = $hostguid.line.split("{").Split("}")[1]
$device = $driver | select-string -pattern 'DeviceInstanceId'
$device = $device.line.split(">")[1]
$computer + " : " + $sid + " : " + $date + " : " + $time + " : " + $eventid + " : " + $slifetime + " : " + $hostguid + " : " + $device + " : " + 'USB 연결' | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_Win7Driver.txt -Append -Encoding UTF8
}
else
{
$datetime = $driver | select-string -pattern 'TimeCreated'
$datetime = [datetime]($datetime.line.split("=").split("/>").split("'")[2])
$datetime = get-date $datetime -format yyyy-MM-dd@hh:mm:ss
$date = $datetime.Split("@")[0]
$time = $datetime.Split("@")[1]
$computer = $driver | select-string -pattern 'Computer'
$computer = $computer.line.split(">")[1]
$sid = $driver | select-string -pattern 'Security UserID'
$sid = $sid.line.split("=").split("/>").split("'")[2]
$elifetime = $driver | select-string -pattern 'UMDFDriverManagerHostShutdown lifetime'
$elifetime = $elifetime.line.split("{").split("}")[1]
$computer + " : " + $sid + " : " + $date + " : " + $time + " : " + $eventid + " : " + $elifetime + " : " + " : " + " : " + 'USB 해제' | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_Win7Driver.txt -Append -Encoding UTF8
}
}
}
