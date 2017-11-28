do {
$ErrorActionPreference = 'silentlycontinue'

if(!(test-path 'C:\ProgramData\soalog'))
{new-item -Path "C:\ProgramData\soalog" -ItemType Directory -Force }

#$drive = (Get-WmiObject Win32_OperatingSystem).Name.split("\")[-2].replace("Harddisk","PHYSICALDRIVE")
#$drive = "\\.\"+$drive
#$sn = (Get-WMIObject win32_physicalmedia | Where-Object {$_.tag -eq $drive} | select SerialNumber).SerialNumber
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




$sw = [System.Diagnostics.Stopwatch]::startnew()

Start-Process powershell.exe -ArgumentList 'C:\Windows\soa\filter.ps1' -Wait -PassThru -WindowStyle Hidden -Verb RunAs

$allname = (Get-ChildItem -path "C:\Windows\System32\winevt\Logs\*Archive-Security*.evtx" | select name).name | Select-Object -First 1
foreach ($name in $allname)
{
#Get-ChildItem -path "C:\Windows\System32\winevt\Logs\Archive-Security*" | Where-Object {($_.Length -eq 20975616) -or ($_.Length -eq 20975616)} | Move-Item -Destination C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_$($_.name)
#Get-ChildItem -path "C:\Windows\System32\winevt\Logs\Archive-Security*" | Move-Item -Destination C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_$name
"C:\Windows\System32\winevt\Logs\"+$name | Move-Item -Destination C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_$name -Force
$name.Dispose()
$allname.Dispose()
$IP.Dispose()
$MAC.Dispose()
$sn.Dispose()
}


Start-Job -ScriptBlock {
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

#$logevents = get-winevent -FilterHashtable @{logname='security'; ID = 4624, 528, 540, 4648, 552, 4634, 538, 4647, 551, 4608, 512, 4625, 529, 530, 531, 532, 533, 534, 536, 537, 539} | foreach {$_.toxml()}
#$logevents = get-winevent -FilterHashtable @{path='C:\Windows\System32\winevt\Logs\Archive-Security-2017-11-01-14-14-58-306.evtx'; ID = 4624, 528, 540, 4648, 552, 4634, 538, 4647, 551, 4608, 512, 4625, 529, 530, 531, 532, 533, 534, 536, 537, 539} | foreach {$_.toxml()}

$log = get-winevent -FilterHashtable @{path='C:\ProgramData\soalog\*Security*.evtx'; ID = 4624, 528, 540, 4648, 552, 4634, 538, 4647, 551, 4608, 512, 4625, 529, 530, 531, 532, 533, 534, 536, 537, 539} | foreach {$_.toxml()}
#foreach ($logon in (get-winevent -FilterHashtable @{path='C:\ProgramData\soalog\*Security*.evtx'; ID = 4624, 528, 540, 4648, 552, 4634, 538, 4647, 551, 4608, 512, 4625, 529, 530, 531, 532, 533, 534, 536, 537, 539} | foreach {$_.toxml()}))


foreach ($logon in $log)
{
$logon = $logon.split("<")
$eventid = $logon | select-string -pattern 'EventID'
$eventid = $eventid.line.split(">")[1]

if (($eventid -eq "4624") -or ($eventid -eq "528") -or ($eventid -eq "540"))
{
$log = 'An account was successfully logged on'
$datetime = $logon | select-string -pattern 'TimeCreated'
$datetime = [datetime]($datetime.line.split("=").split("/>").split("'")[2])
$datetime = get-date $datetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$date = $datetime.Split("@")[0]
#$time = $datetime.Split("@")[1]
$computer = $logon | select-string -pattern 'Computer'
$computer = $computer.line.split(">")[1]
$subjectsid = $logon | select-string -Pattern 'SubjectUserSid'
$subjectsid = $subjectsid.line.Split(">")[1]
$subjectuname = $logon | select-string -Pattern 'SubjectUserName'
$subjectuname = $subjectuname.line.Split(">")[1]
$subjectdname = $logon | select-string -Pattern 'SubjectDomainName'
$subjectdname = $subjectdname.Line.Split(">")[1]
$subjectlogonid = $logon | select-string -Pattern 'SubjectLogonId'
$subjectlogonid = $subjectlogonid.line.Split(">")[1]
$targetuname = $logon | select-string -Pattern 'TargetUserName'
$targetuname = $targetuname.line.Split(">")[1]
$targetdname = $logon | select-string -Pattern 'TargetDomainName'
$targetdname = $targetdname.line.Split(">")[1]
$logontype = $logon | Select-String -Pattern 'LogonType'
$logontype = $logontype.line.split(">")[-1]

$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + ":::;" + $logontype + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
elseif (($eventid -eq "4648") -or ($eventid -eq "552"))
{
$log = 'A logon was attempted using explicit credentials'
$datetime = $logon | select-string -pattern 'TimeCreated'
$datetime = [datetime]($datetime.line.split("=").split("/>").split("'")[2])
$datetime = get-date $datetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$date = $datetime.Split("@")[0]
$time = $datetime.Split("@")[1]
$computer = $logon | select-string -pattern 'Computer'
$computer = $computer.line.split(">")[1]
$subjectsid = $logon | select-string -Pattern 'SubjectUserSid'
$subjectsid = $subjectsid.line.Split(">")[1]
$subjectuname = $logon | select-string -Pattern 'SubjectUserName'
$subjectuname = $subjectuname.line.Split(">")[1]
$subjectdname = $logon | select-string -Pattern 'SubjectDomainName'
$subjectdname = $subjectdname.Line.Split(">")[1]
$subjectlogonid = $logon | select-string -Pattern 'SubjectLogonId'
$subjectlogonid = $subjectlogonid.line.Split(">")[1]
$targetuname = $logon | select-string -Pattern 'TargetUserName'
$targetuname = $targetuname.line.Split(">")[1]
$targetdname = $logon | select-string -Pattern 'TargetDomainName'
$targetdname = $targetdname.line.Split(">")[1]
$logontype = $logon | Select-String -Pattern 'LogonType'
$logontype = $logontype.line.split(">")[-1]

$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + ":::;" + $logontype + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
elseif (($eventid -eq "4634") -or ($eventid -eq "538"))
{
$log = 'An account was logged off'
$datetime = $logon | select-string -pattern 'TimeCreated'
$datetime = [datetime]($datetime.line.split("=").split("/>").split("'")[2])
$datetime = get-date $datetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$date = $datetime.Split("@")[0]
#$time = $datetime.Split("@")[1]
$computer = $logon | select-string -pattern 'Computer'
$computer = $computer.line.split(">")[1]
$targetsid = $logon | select-string -Pattern 'TargetUserSid'
$targetsid = $targetsid.line.Split(">")[1]
$targetuname = $logon | select-string -Pattern 'TargetUserName'
$targetuname = $targetuname.line.Split(">")[1]
$targetdname = $logon | select-string -Pattern 'TargetDomainName'
$targetdname = $targetdname.line.Split(">")[1]
$targetlogonid = $logon | select-string -Pattern 'TargetLogonId'
$targetlogonid = $targetlogonid.line.Split(">")[1]
$logontype = $logon | Select-String -Pattern 'LogonType'
$logontype = $logontype.line.split(">")[-1]
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $computer + ":::;" +  ":::;" +  ":::;" +  ":::;" +  ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + $targetlogonid+ ":::;" + ":::;" + $logontype + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
elseif (($eventid -eq "4647") -or ($eventid -eq "551"))
{
$log = 'User initiated logoff'
$datetime = $logon | select-string -pattern 'TimeCreated'
$datetime = [datetime]($datetime.line.split("=").split("/>").split("'")[2])
$datetime = get-date $datetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$date = $datetime.Split("@")[0]
#$time = $datetime.Split("@")[1]
$computer = $logon | select-string -pattern 'Computer'
$computer = $computer.line.split(">")[1]
$targetsid = $logon | select-string -Pattern 'TargetUserSid'
$targetsid = $targetsid.line.Split(">")[1]
$targetuname = $logon | select-string -Pattern 'TargetUserName'
$targetuname = $targetuname.line.Split(">")[1]
$targetdname = $logon | select-string -Pattern 'TargetDomainName'
$targetdname = $targetdname.line.Split(">")[1]
$logontype = $logon | Select-String -Pattern 'LogonType'
$logontype = $logontype.line.split(">")[-1]
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $computer + ":::;" + ":::;" + ":::;" + ":::;" + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + ":::;" + $logontype + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
elseif (($eventid -eq "4608") -or ($eventid -eq "512"))
{
$log = 'Windows is starting up'
$datetime = $logon | select-string -pattern 'TimeCreated'
$datetime = [datetime]($datetime.line.split("=").split("/>").split("'")[2])
$datetime = get-date $datetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$date = $datetime.Split("@")[0]
#$time = $datetime.Split("@")[1]
$computer = $logon | select-string -pattern 'Computer'
$computer = $computer.line.split(">")[1]
$targetsid = $logon | select-string -Pattern 'TargetUserSid'
$targetsid = $targetsid.line.Split(">")[1]
$targetuname = $logon | select-string -Pattern 'TargetUserName'
$targetuname = $targetuname.line.Split(">")[1]
$targetdname = $logon | select-string -Pattern 'TargetDomainName'
$targetdname = $targetdname.line.Split(">")[1]
$logontype = $logon | Select-String -Pattern 'LogonType'
$logontype = $logontype.line.split(">")[-1]
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $computer + ":::;" + ":::;" + ":::;" +  ":::;" +  ":::;" + ":::;" +  ":::;" +  ":::;" + ":::;" + ":::;" + $logontype + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
elseif (($eventid -eq "4625") -or ($eventid -eq "529") -or ($eventid -eq "530") -or ($eventid -eq "531") -or ($eventid -eq "532") -or ($eventid -eq "533") -or ($eventid -eq "534") -or ($eventid -eq "535") -or ($eventid -eq "536") -or ($eventid -eq "537") -or ($eventid -eq "539"))
{
$log = 'An account failed to log on'
$datetime = $logon | select-string -pattern 'TimeCreated'
$datetime = [datetime]($datetime.line.split("=").split("/>").split("'")[2])
$datetime = get-date $datetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$date = $datetime.Split("@")[0]
#$time = $datetime.Split("@")[1]
$computer = $logon | select-string -pattern 'Computer'
$computer = $computer.line.split(">")[1]
$subjectsid = $logon | select-string -Pattern 'SubjectUserSid'
$subjectsid = $subjectsid.line.Split(">")[1]
$subjectuname = $logon | select-string -Pattern 'SubjectUserName'
$subjectuname = $subjectuname.line.Split(">")[1]
$subjectdname = $logon | select-string -Pattern 'SubjectDomainName'
$subjectdname = $subjectdname.Line.Split(">")[1]
$subjectlogonid = $logon | select-string -Pattern 'SubjectLogonId'
$subjectlogonid = $subjectlogonid.line.Split(">")[1]
$targetsid = $logon | select-string -Pattern 'TargetUserSid'
$targetsid = $targetsid.line.Split(">")[1]
$targetuname = $logon | select-string -Pattern 'TargetUserName'
$targetuname = $targetuname.line.Split(">")[1]
$targetdname = $logon | select-string -Pattern 'TargetDomainName'
$targetdname = $targetdname.line.Split(">")[1]
$failurestatus = $logon | select-string -Pattern 'FailureReason'
$failurestatus = $failurestatus.line.Split(">")[1]
$logontype = $logon | Select-String -Pattern 'LogonType'
$logontype = $logontype.line.split(">")[-1]
if($failurestatus -eq '0XC000005E')
{
$failurecode = 'Currently no logon servers available'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failurecode + ":::;" + $logontype + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC0000064')
{
$failurecode = 'User logon with misspelled or bad user account '
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failurecode + ":::;" + $logontype + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC000006A')
{
$failurecode = 'User logon with misspelled or bad password'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failurecode + ":::;" + $logontype + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0XC000006D')
{
$failurecode = 'Either due to a bad username or authentication information'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failurecode + ":::;" + $logontype + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0XC000006E')
{
$failurecode = 'Unknown user name or bad password'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failurecode + ":::;" + $logontype + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC000006F')
{
$failurecode = 'User logon outside authorized hours'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failurecode + ":::;" + $logontype + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC0000070')
{
$failurecode = 'User logon from unauthroized workstation'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failurecode + ":::;" + $logontype + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC0000071')
{
$failurecode = 'User logon with expired password'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failurecode + ":::;" + $logontype + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC0000072')
{
$failurecode = 'User logon to account disabled by administrator'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failurecode + ":::;" + $logontype + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC00000DC')
{
$failurecode = 'Sam Server was in the wrong state to perform the desired operation'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failurecode + ":::;" + $logontype + ":::;"  | out-file C:\ProgramData\soalog\${env:COMPUTERNAME}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC0000133')
{
$failurecode = 'Clocks between DC and other computer too far out of sync'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failurecode  + ":::;" + $logontype + ":::;" | out-file C:\ProgramData\soalog\${env:COMPUTERNAME}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC000015B')
{
$failurecode = 'The user has not been granted the requested logon right at this machine'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failurecode + ":::;" + $logontype + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC000018C')
{
$failurecode = 'Due to the trust relationship between the primary domain and the trusted domain failed'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failurecode + ":::;" + $logontype + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC0000192')
{
$failurecode = 'Netlogon service was not started'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failurecode + ":::;" + $logontype + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC0000193')
{
$failurecode = 'User logon with expired account'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failurecode + ":::;" + $logontype + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC0000224')
{
$failurecode = 'User is required to change password at next logon'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $time + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failurecode + ":::;" + $logontype + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC0000225')
{
$failurecode = 'Evidently a bug in Windows and not a risk'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failurecode + ":::;" + $logontype + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC0000234')
{
$failurecode = 'User logon with account locked'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failurecode + ":::;" + $logontype + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC00002EE')
{
$failurecode = 'An Error occured during Logon'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failurecode + ":::;" + $logontype + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC0000413')
{
$failurecode = 'The specified account is not allowed to authenticate to this machine under the protection of authentication firewall'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failurecode + ":::;" + $logontype + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
}
}
}
$logon.Dispose()
$eventid.Dispose()
$datetime.Dispose()
$log.Dispose()
$computer.Dispose()
$subjectsid.Dispose()
$subjectuname.Dispose()
$subjectdname.Dispose()
$subjectlogonid.Dispose()
$targetuname.Dispose()
$targetdname.Dispose()
$targetsid.Dispose()
$targetlogonid.Dispose()
$failurestatus.Dispose()
$failurecode.Dispose()
$logontype.Dispose()
$sn.Dispose()
$ip.Dispose()
$MAC.Dispose()
$log.Dispose()
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


#$events = get-winevent -FilterHashtable @{logname='security'; ID = 4656, 4659, 4660, 4662, 4663} -MaxEvents 40000 | foreach {$_.toxml()}
#$id = "4656", "4659", "4660", "4662", "4663", "4624", "528", "540", "4648", "552", "4634", "538", "4647", "551", "4608", "512", "4625", "529", "530", "531", "532", "533", "534", "536", "537", "539"
#$events = get-winevent -FilterHashtable @{path='C:\Windows\System32\winevt\Logs\Archive-Security-2017-09-26-06-30-35-230.evtx'; ID = 4656, 4659, 4660, 4662, 4663} | foreach {$_.toxml()}
#$events = get-winevent -FilterHashtable @{path='C:\Windows\System32\winevt\Logs\Archive-Security-2017-11-01-14-14-58-306.evtx'} | foreach {$_.toxml()}

$eprocess = "C:\/Windows\/System32\/svchost.exe", "C:\/Program Files (x86)\/Google\/Update\/GoogleUpdate.exe", "C:\/Program Files (x86)\/INCAInternet\/nProtect Online Security\/nosstarter.npe", "C:\/program files (x86)\/markany\/webdrmnoax\/bin\/mawebdrmagent.exe", "C:\/Program Files (x86)\/NVIDIA Corporation\/Update Core\/NvTmMon.exe", "C:\/Program Files (x86)\/Realtek\/USB Wireless LAN Utility\/RtWLan.exe", "C:\/Program Files (x86)\/Western Digital\/Discovery\/Current\/WD Discovery.exe", "C:\/Program Files (x86)\/Western Digital\/WD Drive Manager\/WDDriveService.exe", "C:\/Program Files (x86)\/Wizvera\/Common\/wpmsvc\/wpmsvc.exe", "C:\/Program Files\/NVIDIA Corporation\/Display.NvContainer\/NVDisplay.Container.exe", "C:\/Program Files\/NVIDIA Corporation\/Display\/nvtray.exe", "C:\/Program Files\/WindowsApps\/microsoft.windowscommunicationsapps_17.8600.40525.0_x64__8wekyb3d8bbwe\/HxTsr.exe", "C:\/Windows\/System32\/conhost.exe", "C:\/Windows\/System32\/consent.exe", "C:\/Windows\/System32\/csrss.exe", "C:\/Windows\/System32\/DeviceCensus.exe", `
"C:\/Windows\/System32\/dllhost.exe", "C:\/Windows\/SysWOW64\/dllhost.exe", "C:\/Windows\/System32\/fontdrvhost.exe", "C:\/Windows\/SysWOW64\/fontdrvhost.exe", "C:\/Windows\/System32\/InputMethod\/CHS\/ChsIME.exe", "C:\/Windows\/System32\/lsass.exe", "C:\/Windows\/System32\/msfeedssync.exe", "C:\/Windows\/SysWOW64\/reg.exe", "C:\/Windows\/System32\/reg.exe", "C:\/Windows\/System32\/SearchFilterHost.exe", "C:\/Windows\/System32\/SearchIndexer.exe", "C:\/Windows\/System32\/Services.exe", "C:\/Windows\/SysWOW64\/services.exe", "C:\/Windows\/System32\/sihost.exe", "C:\/Windows\/System32\/smartscreen.exe", "C:\/Windows\/System32\/SppExtComObj.Exe", "C:\/Windows\/System32\/sppsvc.exe", "C:\/Windows\/System32\/taskhostw.exe", "C:\/Windows\/System32\/wbem\/WMIC.exe", "C:\/Windows\/System32\/wbem\/WmiPrvSE.exe", "C:\/Windows\/SysWOW64\/wbem\/WmiPrvSE.exe",`
"SearchUI.exe", "ShellExperienceHost.exe", "C:\/Program Files\/ESTsoft\/ALYac\/AYUpdSrv.aye", "C:\/Program Files\/ESTsoft\/ALYac\/AYAgent.aye", "C:\/Program Files (x86)\/Western Digital\/WD App Manager\/Plugins\/WD Backup\/App\/WDBackupService.exe", "C:\/Program Files\/Microsoft SQL Server\/MSSQL13.H\/MSSQL\/Binn\/sqlservr.exe", "C:\/Windows\/System32\/wermgr.exe", "C:\/Windows\/SysWOW64\/wermgr.exe", "C:\/Program Files\/ESTsoft\/ALYac\/AYRTSrv.aye", "C:\/Windows\/System32\/perfmon.exe", "C:\/Windows\/SysWOW64", "C:\/Program Files (x86)\/INCAInternet\/nProtect Online Security\/npUpdateC.exe", "C:\/Program Files\/ESTsoft\/ALYac\/ALNotice.exe", "C:\/Program Files (x86)\/Western Digital\/WD Utilities\/WDDriveUtilitiesHelper.exe",`
"C:\/Program Files (x86)\/Markany\/WebDRMNoAX\/bin\/MaWebDRMAgent.exe", "C:\/Windows\/System32\/Taskmgr.exe", "C:\/Windows\/System32\/services.exe", "C:\/Windows\/System32\/lsass.exe", "C:\/Program Files (x86)\/ESTsoft\/Common\/ALSTSCollector.exe", "C:\/Windows\/KMS-R@1nHook.exe",`
"C:\/Program Files (x86)\/NVIDIA Corporation\/NvContainer\/nvcontainer.exe", "C:\/Windows\/System32\/taskhostw.exe", "C:\/Windows\/System32\/wbem\/WmiPrvSE.exe", "C:\/Windows\/System32\/backgroundTaskHost.exe", "C:\/Windows\/SystemApps\/ShellExperienceHost_cw5n1h2txyewy\/ShellExperienceHost.exe", "C:\/Program Files (x86)\/ESTsoft\/ALUpdate\/ALUpProduct.exe", "C:\/Program Files\/KCP\/kcppayplugin.exe", "C:\/Windows\/System32\/WerFault.exe", "C:\/Windows\/System32\/winlogon.exe", "C:\/Program Files\/Microsoft SQL Server\/MSRS13.H\/Reporting Services\/ReportServer\/bin\/ReportingServicesService.exe",`
"C:\/Program Files\/Microsoft SQL Server\/MSSQL13.H\/MSSQL\/Binn\/Polybase\/mpdwsvc.exe", "C:\/Program Files\/Windows Defender\/MsMpEng.exe", "C:\/Program Files\/NVIDIA Corporation\/ShadowPlay\/nvspcaps64.exe", "C:\/Windows\/SoftwareDistribution\/Download\/Install\/NIS_Delta_Patch.exe", "C:\/Windows\/System32\/MpSigStub.exe", "C:\/Program Files (x86)\/INCAInternet\/nProtect Online Security\/npUpdateC.exe", "C:\/Program Files\/Realtek\/Audio\/HDA\/RAVCpl64.exe", "C:\/Windows\/System32\/RuntimeBroker.exe", "C:\/Windows\/System32\/mobsync.exe",`
"C:\/Program Files\/KCP\/kcppayplugin.exe", "C:\/Windows\/System32\/WerFault.exe", "C:\/Program Files (x86)\/INCAInternet\/nProtect Online Security\/nossvc.exe", "C:\/Windows\/System32\/dwm.exe", "C:\/Windows\/System32\/CompatTelRunner.exe", "C:\/Windows\/System32\/rundll32.exe", "C:\/Program Files (x86)\/Common Files\/Adobe\/AdobeGCClient\/AGSService.exe",`
"C:\/Windows\/System32\/InputMethod\/CHS\/ChsIME.exe", "C:\/Program Files\/WindowsApps\/Microsoft.Windows.Photos_2017.35071.16410.0_x64__8wekyb3d8bbwe\/Microsoft.Photos.exe", "C:\/Program Files\/NVIDIA Corporation\/NvContainer\/nvcontainer.exe", "C:\/Windows\/System32\/WindowsPowerShell\/v1.0\/powershell.exe", "C:\/Windows\/System32\/WindowsPowerShell\/v1.0\/Modules\/BitsTransfer", "C:\/Program Files\/ESTsoft\/ALYac\/AYHost.aye", "C:\/Windows\/System32\/WindowsPowerShell\/v1.0\/powershell_ise.exe",`
"C:\/Program Files\/ESTsoft\/ALYac\/AYPop.aye"

#"C:\Program Files (x86)\ESTsoft\ALToolBar\atbsvc.exe", "C:\/Windows\/System32\/WindowsPowerShell\/v1.0\/powershell_ise.exe"
$directoryonly = get-content C:\ProgramData\soalog\path.txt

#$eextension = ".nls", ".dll", ".mui", ".clb", ".ini", ".ttc", ".xml", ".log", ".ldb", ".edb-journal", ".tlb", ".deb", ".json", ".pages", ".insertion", ".css", ".ar", ".de", ".otf", ".svg", ".js", ".pt_PT", ".zh_TW", ".it", ".fr", ".en", ".yahoo", ".option", ".woff",`
#".ttf", ".eot", ".html", ".cat", ".drv", ".dat", ".manifest", ".sdb", ".aym", ".scd", ".cdf-ms", ".ico", ".fon", ".icm", ".tingo", ".compact", ".config", ".configuration", ".core", ".db", ".pris", ".pri", ".web", ".xam"

$eextension = "nls", "dll", "mui", "clb", "ini", "ttc", "xml", "tmp", "log", "ldb", "edb-journal", "tlb", "deb", "json", "pages", "insertion", "css", "ar", "de", "otf", "svg", "js", "pt_PT", "zh_TW", "it", "fr", "en", "yahoo", `
"option", "woff", "ttf", "eot", "cat", "drv", "dat", "manifest", "sdb", "aym", "scd", "cdf-ms", "ico", "fon", "icm", "tingo", "compact", "config", "configuration", "core", "db", "pris", "pri", "web", "xam", "aye", "mta", "library-ms", "automaticDestinations-ms", "odf"


#foreach ($security in (get-winevent -FilterHashtable @{path='C:\ProgramData\soalog\*Security*.evtx'; ID = 4656, 4659, 4660, 4662, 4663} | foreach {$_.toxml()}))
$oalog = get-winevent -FilterHashtable @{path='C:\ProgramData\soalog\*Security*.evtx'; ID = 4656, 4659, 4660, 4662, 4663} | foreach {$_.toxml()}

foreach ($security in $oalog)
{
$security = $security.split("<")
$eventid = $security | select-string -pattern 'EventID'
$eventid = $eventid.line.split(">")[1]

$objecttype = $security | select-string -pattern 'ObjectType'
$objecttype = $objecttype.Line.split("=").split(">")[2]
if ($objecttype -eq "File")
{
$objectserver = $security | select-string -Pattern 'ObjectServer'
$objectserver = $objectserver.line.Split("=").split(">")[2]
if ($objectserver -eq "Security")
{
$processname = $security | select-string -pattern 'ProcessName'
$processname = $processname.line.Split("=").split(">")[2]
$processname = $processname.Replace("\","\/")
if ($processname | where-object {$_ -notin $eprocess})
{
$objectname = $security | select-string -pattern 'ObjectName'
$objectname = $objectname.line.Split("=").split(">")[2]

if ($objectname | Where-Object {$_ -notin $directoryonly})
{
#if ($objectname | where-object {$_ -notmatch $eextension})
#{

$root = $objectname.split(":")[0]
$file = $objectname.Split("\")[-1]

if($file | where-object {$_ -ne $null})
{
$directory = $objectname.split("\") | select -SkipLast 1
$directory = $directory -join '\/'
$datetime = $security | select-string -pattern 'TimeCreated'
$datetime = [datetime]($datetime.line.split("=").split("/>").split("'")[2])
$datetime = get-date $datetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$date = $datetime.Split("@")[0]
#$time = $datetime.Split("@")[1]
$computer = $security | select-string -pattern 'Computer'
$computer = $computer.line.split(">")[1]
$sid = $security | select-string -pattern 'SubjectUserSid'
$sid = $sid.line.split("=").split(">")[2]
$username = $security | select-string -pattern 'SubjectUserName'
$username = $username.line.Split("=").split(">")[2]
$logonid = $security | select-string -pattern 'SubjectLogonId'
$logonid = $logonid.line.Split("=").split(">")[2]
$domainname = $security | select-string -pattern 'SubjectDomainName'
$domainname = $domainname.line.Split("=").split(">")[2]
$accessmask = $security | select-string -pattern 'AccessMask'
$accessmask = $accessmask.line.Split("=").split(">")[2]
$ext = $file.split(".")[-1]
if ($ext | Where-Object {$_ -notin $eextension})
{
if ($file -eq $ext)
{
$next = $null
#$directoryf = $directory+"\"+$file
if($accessmask -eq "0x1")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" +"ReadData (or ListDirectory)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($accessmask -eq "0x2")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "WriteData (or AddFile)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($accessmask -eq "0x4")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "AppendData (or AddSubdirectory)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($accessmask -eq "0x40")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "DeleteChild" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($accessmask -eq "0x80")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "ReadAttributes" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($accessmask -eq "0x100")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "WriteAttributes" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($accessmask -eq "0x10000")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "DELETE" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($accessmask -eq "0x20000")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "READ_CONTROL" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($accessmask -eq "0x20")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "Execute (or Traverse)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}

elseif($accessmask -eq "0x100000")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "Synchronize" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($accessmask -eq "0x200000")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "ReadControl" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($accessmask -eq "0x400000")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "WriteDAC" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($accessmask -eq "0x800000")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "WriteOwner" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
}
elseif ($file -ne $ext)
{
$ext = "."+$file.split(".")[-1]

if($accessmask -eq "0x1")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "ReadData (or ListDirectory)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($accessmask -eq "0x2")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "WriteData (or AddFile)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($accessmask -eq "0x4")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "AppendData (or AddSubdirectory)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($accessmask -eq "0x40")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "DeleteChild" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($accessmask -eq "0x80")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "ReadAttributes" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($accessmask -eq "0x100")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "WriteAttributes" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($accessmask -eq "0x10000")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "DELETE" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($accessmask -eq "0x20000")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "READ_CONTROL" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}

elseif($accessmask -eq "0x20")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "FileExecute (or FileTraverse)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($accessmask -eq "0x100000")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "Synchronize" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($accessmask -eq "0x200000")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "ReadControl" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($accessmask -eq "0x400000")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "WriteDAC" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($accessmask -eq "0x800000")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "WriteOwner" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
}
}
}
}
}
$processname.Dispose()
$objectname.Dispose()
$root.Dispose()
$file.Dispose()
$directoryonly.Dispose()
$datetime.Dispose()
$computer.Dispose()
$sid.Dispose()
$username.Dispose()
$logonid.Dispose()
$domainname.Dispose()
$accessmask.Dispose()
$ext.Dispose()
$file.Dispose()
}



elseif ($objectserver -match "MTP")
{
$datetime = $security | select-string -pattern 'TimeCreated'
$datetime = [datetime]($datetime.line.split("=").split("/>").split("'")[2])
$datetime = get-date $datetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$date = $datetime.Split("@")[0]
#$time = $datetime.Split("@")[1]
$computer = $security | select-string -pattern 'Computer'
$computer = $computer.line.split(">")[1]
$sid = $security | select-string -pattern 'SubjectUserSid'
$sid = $sid.line.split("=").split(">")[2]
$username = $security | select-string -pattern 'SubjectUserName'
$username = $username.line.Split("=").split(">")[2]
$logonid = $security | select-string -pattern 'SubjectLogonId'
$logonid = $logonid.line.Split("=").split(">")[2]
$domainname = $security | select-string -pattern 'SubjectDomainName'
$domainname = $domainname.line.Split("=").split(">")[2]
$objectname = $security | select-string -pattern 'ObjectName'
$objectname = $objectname.line.Split("=").split(">")[2]
$ext = "."+$objectname.split(".")[-1]
$accessmask = $security | select-string -pattern 'AccessMask'
$accessmask = $accessmask.line.Split("=").split(">")[2]
$additionalinfo2 = $security | select-string -Pattern 'AdditionalInfo2'
$additionalinfo2 = $additionalinfo2.line.split("-").split(">")[1]
if($accessmask -eq "0x120116")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x120116","Write") + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $objectname + ":::;" + $ext + ":::;" + $additionalinfo2 + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa_mtp.txt -Append -encoding utf8
}
elseif($accessmask -eq "0x120089")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x120089","READ") + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $datetime + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $objectname + ":::;" + $ext + ":::;" + $additionalinfo2 + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa_mtp.txt -Append -encoding utf8
}
$datetime.Dispose()
$computer.Dispose()
$sid.Dispose()
$username.Dispose()
$logonid.Dispose()
$domainname.Dispose()
$objectname.Dispose()
$ext.Dispose()
$accessmask.Dispose()
$additionalinfo2.Dispose()
}
$objectserver.Dispose()
}
$security.Dispose()
$eventid.Dispose()
$objecttype.Dispose()
$objectserver.Dispose()
$eprocess.Dispose()
$directoryonly.Dispose()
$eextension.Dispose()
}
$sn.Dispose()
$IP.Dispose()
$MAC.Dispose()
$oalog.Dispose()



$sw.stop()
$sw.Elapsed.tostring('dd\.hh\"mm\:ss\.fff')
$sw = [System.Diagnostics.Stopwatch]::startnew()

if (test-path 'C:\ProgramData\soalog\*_logon.txt')
{
$uniquelogon = Get-Content  C:\ProgramData\soalog\*_logon.txt | select -unique
$uniquelogon | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_logonoff.txt -Append -encoding utf8
$uniquelogon.dispose()
}
if (Test-Path 'C:\ProgramData\soalog\*_oa.txt')
{
$uniqueoa = Get-Content  C:\ProgramData\soalog\*_oa.txt | select -unique
$uniqueoa | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_oa_filtered.txt -Append -encoding utf8
$uniqueoa.dispose()
}

Import-Module bitstransfer
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "C:\ProgramData\soalog\*_logonoff.txt", "C:\ProgramData\soalog\*_oa_mtp.txt", "C:\ProgramData\soalog\*_oa_filtered.txt", "C:\ProgramData\soalog\*Security*.evtx"
#$src = "C:\ProgramData\soalog\*_logonoff.txt", "C:\ProgramData\soalog\*_oa_mtp.txt", "C:\ProgramData\soalog\*_oa_filtered.txt"
Get-ChildItem -path $src |
foreach {
$dst = "http://cdisc.co.kr:1024/soa/upload/$($_.name)" # server directory with write permissions
$job = Start-BitsTransfer -source $($_.FullName) -Destination $dst -Credential $cred -TransferType Upload -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 20;}
if ($job.JobState -eq "Transferred")
{
Remove-Item $($_.FullName)
Remove-Item "C:\ProgramData\soalog\*_logon.txt", "C:\ProgramData\soalog\*_oa.txt"
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

#Clear-Variable name, allname, logon, eventid, datetime, computer, subjectsid, subjectuname, subjectdname, subjectlogonid, targetuname, targetdname, targetlogonid, filurestatus, eprocess, directoryonly, eextension, security, objecttype, objectserver, processname, objectname, root, file, directory, sid, username, logonid, domainname, accessmask, ext, objectserver, additionalinfo2


sleep 5
}
while ($true)