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

if (Test-Path 'C:\ProgramData\soalog\*.evtx')
{
if (Test-Path 'C:\ProgramData\soalog\*_oa.txt')
{
Remove-Item 'C:\ProgramData\soalog\*_oa.txt' -Force
Remove-Item 'C:\ProgramData\soalog\*_logon.txt' -Force
}
elseif (!(Test-Path 'C:\ProgramData\soalog\*_oa.txt'))
{
Remove-Item 'C:\ProgramData\soalog\*.evtx' -Force
}
}


$sw = [System.Diagnostics.Stopwatch]::startnew()

<#
$proc = Start-Process powershell.exe -ArgumentList 'C:\Windows\soa\filter.ps1' -Wait -PassThru -WindowStyle Hidden -Verb RunAs

$proc.dispose()

#>

$allname = (Get-ChildItem -path "C:\Windows\System32\winevt\Logs\*Archive-Security*.evtx" | select name).name | Select-Object -First 1
foreach ($name in $allname)
{
#Get-ChildItem -path "C:\Windows\System32\winevt\Logs\Archive-Security*" | Where-Object {($_.Length -eq 20975616) -or ($_.Length -eq 20975616)} | Move-Item -Destination C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_$($_.name)
#Get-ChildItem -path "C:\Windows\System32\winevt\Logs\Archive-Security*" | Move-Item -Destination C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_$name
"C:\Windows\System32\winevt\Logs\"+$name | Move-Item -Destination C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_$name -Force
$name.Dispose()
$sn.Dispose()
}
$allname.Dispose()



$job = Start-Job -ScriptBlock {

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


get-winevent -FilterHashtable @{path ='C:\ProgramData\soalog\*.evtx'; ID = 4624, 528, 540, 4648, 552, 4634, 538, 4647, 551, 4608, 512, 4625, 529, 530, 531, 532, 533, 534, 536, 537, 539} | foreach {
$logonofflog = [xml] $_.toxml()
$PSObject = New-Object PSObject
$datetime = $logonofflog.Event.System.TimeCreated.SystemTime.Split(".")[0]+"+09:00"
$eventid = $logonofflog.Event.System.EventID
$logonoff = "" | select Computer, SubjectUserSid, SubjectUserName, SubjectDomainName, SubjectLogonId, TargetUserName, TargetDomainName, TargetUserSid, TargetLogonId, Status, LogonType

$logonofflog.Event.EventData.Data | foreach {
            $PSObject | Add-Member NoteProperty $_.Name $_."#text"
}        
             
        $logonoff.Computer = $PSObject.Computer
        $logonoff.SubjectUserSid = $PSObject.SubjectUserSid
        $logonoff.SubjectUserName = $PSObject.SubjectUserName
        $logonoff.SubjectDomainName = $PSObject.SubjectDomainName
        $logonoff.SubjectLogonId = $PSObject.SubjectLogonId
        $logonoff.TargetUserName = $PSObject.TargetUserName
        $logonoff.TargetDomainName = $PSObject.TargetDomainName
        $logonoff.TargetUserSid = $PSObject.TargetUserSid
        $logonoff.TargetLogonId = $PSObject.TargetLogonId
        $logonoff.Status = $PSObject.Status
        $logonoff.LogonType = $PSObject.LogonType


 if (($eventid -eq "4624") -or ($eventid -eq "528") -or ($eventid -eq "540"))
{
$log = 'An account was successfully logged on'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $logonoff.Computer + ":::;" + $logonoff.SubjectUserSid + ":::;" + $logonoff.SubjectUserName + ":::;" + $logonoff.SubjectDomainName + ":::;" + $logonoff.SubjectLogonId + ":::;" + ":::;" + $logonoff.TargetUserName + ":::;" + $logonoff.TargetDomainName + ":::;" + ":::;" + ":::;" + $logonoff.LogonType + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$log.Dispose()
}

elseif (($eventid -eq "4648") -or ($eventid -eq "552"))
{
$log = 'A logon was attempted using explicit credentials'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $logonoff.Computer + ":::;" + $logonoff.SubjectUserSid + ":::;" + $logonoff.SubjectUserName + ":::;" + $logonoff.SubjectDomainName + ":::;" + $logonoff.SubjectLogonId + ":::;" + ":::;" + $logonoff.TargetUserName + ":::;" + $logonoff.TargetDomainName + ":::;" + ":::;" + ":::;" + $logonoff.LogonType + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$log.Dispose()
}

elseif (($eventid -eq "4634") -or ($eventid -eq "538"))
{
$log = 'An account was logged off'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $logonoff.Computer + ":::;" +  ":::;" +  ":::;" +  ":::;" +  ":::;" + $logonoff.TargetUserSid + ":::;" + $logonoff.TargetUserName + ":::;" + $logonoff.TargetDomainName + ":::;" + $logonoff.TargetLogonId+ ":::;" + ":::;" + $logonoff.LogonType + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$log.Dispose()
}

elseif (($eventid -eq "4647") -or ($eventid -eq "551"))
{
$log = 'User initiated logoff'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $logonoff.Computer + ":::;" + ":::;" + ":::;" + ":::;" + ":::;" + $logonoff.TargetUserSid + ":::;" + $logonoff.TargetUserName + ":::;" + $logonoff.TargetDomainName + ":::;" + ":::;" + ":::;" + $logonoff.LogonType + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$log.Dispose()
}

elseif (($eventid -eq "4608") -or ($eventid -eq "512"))
{
$log = 'Windows is starting up'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $logonoff.Computer + ":::;" + ":::;" + ":::;" +  ":::;" +  ":::;" + ":::;" +  ":::;" +  ":::;" + ":::;" + ":::;" + $logonoff.LogonType + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$log.Dispose()
}

elseif (($eventid -eq "4625") -or ($eventid -eq "529") -or ($eventid -eq "530") -or ($eventid -eq "531") -or ($eventid -eq "532") -or ($eventid -eq "533") -or ($eventid -eq "534") -or ($eventid -eq "535") -or ($eventid -eq "536") -or ($eventid -eq "537") -or ($eventid -eq "539"))
{
$log = 'An account failed to log on'

if($logonoff.Status -eq '0XC000005E')
{
$FailureReason = 'Currently no logon servers available'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $logonoff.Computer + ":::;" + $logonoff.SubjectUserSid + ":::;" + $logonoff.SubjectUserName + ":::;" + $logonoff.SubjectDomainName + ":::;" + $logonoff.SubjectLogonId + ":::;" + $logonoff.TargetUserSid + ":::;" + $logonoff.TargetUserName + ":::;" + $logonoff.TargetDomainName + ":::;" + ":::;" + $FailureReason + ":::;" + $logonoff.LogonType + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$FailureReason.Dispose()
}
elseif($logonoff.Status -eq '0xC0000064')
{
$FailureReason = 'User logon with misspelled or bad user account '
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $logonoff.Computer + ":::;" + $logonoff.SubjectUserSid + ":::;" + $logonoff.SubjectUserName + ":::;" + $logonoff.SubjectDomainName + ":::;" + $logonoff.SubjectLogonId + ":::;" + $logonoff.TargetUserSid + ":::;" + $logonoff.TargetUserName + ":::;" + $logonoff.TargetDomainName + ":::;" + ":::;" + $FailureReason + ":::;" + $logonoff.LogonType + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$FailureReason.Dispose()
}
elseif($logonoff.Status -eq '0xC000006A')
{
$FailureReason = 'User logon with misspelled or bad password'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $logonoff.Computer + ":::;" + $logonoff.SubjectUserSid + ":::;" + $logonoff.SubjectUserName + ":::;" + $logonoff.SubjectDomainName + ":::;" + $logonoff.SubjectLogonId + ":::;" + $logonoff.TargetUserSid + ":::;" + $logonoff.TargetUserName + ":::;" + $logonoff.TargetDomainName + ":::;" + ":::;" + $FailureReason + ":::;" + $logonoff.LogonType + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$FailureReason.Dispose()
}
elseif($logonoff.Status -eq '0XC000006D')
{
$FailureReason = 'Either due to a bad username or authentication information'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $logonoff.Computer + ":::;" + $logonoff.SubjectUserSid + ":::;" + $logonoff.SubjectUserName + ":::;" + $logonoff.SubjectDomainName + ":::;" + $logonoff.SubjectLogonId + ":::;" + $logonoff.TargetUserSid + ":::;" + $logonoff.TargetUserName + ":::;" + $logonoff.TargetDomainName + ":::;" + ":::;" + $FailureReason + ":::;" + $logonoff.LogonType + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$FailureReason.Dispose()
}
elseif($logonoff.Status -eq '0XC000006E')
{
$FailureReason = 'Unknown user name or bad password'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $logonoff.Computer + ":::;" + $logonoff.SubjectUserSid + ":::;" + $logonoff.SubjectUserName + ":::;" + $logonoff.SubjectDomainName + ":::;" + $logonoff.SubjectLogonId + ":::;" + $logonoff.TargetUserSid + ":::;" + $logonoff.TargetUserName + ":::;" + $logonoff.TargetDomainName + ":::;" + ":::;" + $FailureReason + ":::;" + $logonoff.LogonType + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$FailureReason.Dispose()
}
elseif($logonoff.Status -eq '0xC000006F')
{
$FailureReason = 'User logon outside authorized hours'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $logonoff.Computer + ":::;" + $logonoff.SubjectUserSid + ":::;" + $logonoff.SubjectUserName + ":::;" + $logonoff.SubjectDomainName + ":::;" + $logonoff.SubjectLogonId + ":::;" + $logonoff.TargetUserSid + ":::;" + $logonoff.TargetUserName + ":::;" + $logonoff.TargetDomainName + ":::;" + ":::;" + $FailureReason + ":::;" + $logonoff.LogonType + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$FailureReason.Dispose()
}
elseif($logonoff.Status -eq '0xC0000070')
{
$FailureReason = 'User logon from unauthroized workstation'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $logonoff.Computer + ":::;" + $logonoff.SubjectUserSid + ":::;" + $logonoff.SubjectUserName + ":::;" + $logonoff.SubjectDomainName + ":::;" + $logonoff.SubjectLogonId + ":::;" + $logonoff.TargetUserSid + ":::;" + $logonoff.TargetUserName + ":::;" + $logonoff.TargetDomainName + ":::;" + ":::;" + $FailureReason + ":::;" + $logonoff.LogonType + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$FailureReason.Dispose()
}
elseif($logonoff.Status -eq '0xC0000071')
{
$FailureReason = 'User logon with expired password'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $logonoff.Computer + ":::;" + $logonoff.SubjectUserSid + ":::;" + $logonoff.SubjectUserName + ":::;" + $logonoff.SubjectDomainName + ":::;" + $logonoff.SubjectLogonId + ":::;" + $logonoff.TargetUserSid + ":::;" + $logonoff.TargetUserName + ":::;" + $logonoff.TargetDomainName + ":::;" + ":::;" + $FailureReason + ":::;" + $logonoff.LogonType + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$FailureReason.Dispose()
}
elseif($logonoff.Status -eq '0xC0000072')
{
$FailureReason = 'User logon to account disabled by administrator'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $logonoff.Computer + ":::;" + $logonoff.SubjectUserSid + ":::;" + $logonoff.SubjectUserName + ":::;" + $logonoff.SubjectDomainName + ":::;" + $logonoff.SubjectLogonId + ":::;" + $logonoff.TargetUserSid + ":::;" + $logonoff.TargetUserName + ":::;" + $logonoff.TargetDomainName + ":::;" + ":::;" + $FailureReason + ":::;" + $logonoff.LogonType + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$FailureReason.Dispose()
}
elseif($logonoff.Status -eq '0xC00000DC')
{
$FailureReason = 'Sam Server was in the wrong state to perform the desired operation'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $logonoff.Computer + ":::;" + $logonoff.SubjectUserSid + ":::;" + $logonoff.SubjectUserName + ":::;" + $logonoff.SubjectDomainName + ":::;" + $logonoff.SubjectLogonId + ":::;" + $logonoff.TargetUserSid + ":::;" + $logonoff.TargetUserName + ":::;" + $logonoff.TargetDomainName + ":::;" + ":::;" + $FailureReason + ":::;" + $logonoff.LogonType + ":::;"  | out-file C:\ProgramData\soalog\${env:COMPUTERNAME}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$FailureReason.Dispose()
}
elseif($logonoff.Status -eq '0xC0000133')
{
$FailureReason = 'Clocks between DC and other computer too far out of sync'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $logonoff.Computer + ":::;" + $logonoff.SubjectUserSid + ":::;" + $logonoff.SubjectUserName + ":::;" + $logonoff.SubjectDomainName + ":::;" + $logonoff.SubjectLogonId + ":::;" + $logonoff.TargetUserSid + ":::;" + $logonoff.TargetUserName + ":::;" + $logonoff.TargetDomainName + ":::;" + ":::;" + $FailureReason  + ":::;" + $logonoff.LogonType + ":::;" | out-file C:\ProgramData\soalog\${env:COMPUTERNAME}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$FailureReason.Dispose()
}
elseif($logonoff.Status -eq '0xC000015B')
{
$FailureReason = 'The user has not been granted the requested logon right at this machine'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $logonoff.Computer + ":::;" + $logonoff.SubjectUserSid + ":::;" + $logonoff.SubjectUserName + ":::;" + $logonoff.SubjectDomainName + ":::;" + $logonoff.SubjectLogonId + ":::;" + $logonoff.TargetUserSid + ":::;" + $logonoff.TargetUserName + ":::;" + $logonoff.TargetDomainName + ":::;" + ":::;" + $FailureReason + ":::;" + $logonoff.LogonType + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$FailureReason.Dispose()
}
elseif($logonoff.Status -eq '0xC000018C')
{
$FailureReason = 'Due to the trust relationship between the primary domain and the trusted domain failed'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $logonoff.Computer + ":::;" + $logonoff.SubjectUserSid + ":::;" + $logonoff.SubjectUserName + ":::;" + $logonoff.SubjectDomainName + ":::;" + $logonoff.SubjectLogonId + ":::;" + $logonoff.TargetUserSid + ":::;" + $logonoff.TargetUserName + ":::;" + $logonoff.TargetDomainName + ":::;" + ":::;" + $FailureReason + ":::;" + $logonoff.LogonType + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$FailureReason.Dispose()
}
elseif($logonoff.Status -eq '0xC0000192')
{
$FailureReason = 'Netlogon service was not started'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $logonoff.Computer + ":::;" + $logonoff.SubjectUserSid + ":::;" + $logonoff.SubjectUserName + ":::;" + $logonoff.SubjectDomainName + ":::;" + $logonoff.SubjectLogonId + ":::;" + $logonoff.TargetUserSid + ":::;" + $logonoff.TargetUserName + ":::;" + $logonoff.TargetDomainName + ":::;" + ":::;" + $FailureReason + ":::;" + $logonoff.LogonType + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$FailureReason.Dispose()
}
elseif($logonoff.Status -eq '0xC0000193')
{
$FailureReason = 'User logon with expired account'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $logonoff.Computer + ":::;" + $logonoff.SubjectUserSid + ":::;" + $logonoff.SubjectUserName + ":::;" + $logonoff.SubjectDomainName + ":::;" + $logonoff.SubjectLogonId + ":::;" + $logonoff.TargetUserSid + ":::;" + $logonoff.TargetUserName + ":::;" + $logonoff.TargetDomainName + ":::;" + ":::;" + $FailureReason + ":::;" + $logonoff.LogonType + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$FailureReason.Dispose()
}
elseif($logonoff.Status -eq '0xC0000224')
{
$FailureReason = 'User is required to change password at next logon'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $time + ":::;" + $logonoff.Computer + ":::;" + $logonoff.SubjectUserSid + ":::;" + $logonoff.SubjectUserName + ":::;" + $logonoff.SubjectDomainName + ":::;" + $logonoff.SubjectLogonId + ":::;" + $logonoff.TargetUserSid + ":::;" + $logonoff.TargetUserName + ":::;" + $logonoff.TargetDomainName + ":::;" + ":::;" + $FailureReason + ":::;" + $logonoff.LogonType + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$FailureReason.Dispose()
}
elseif($logonoff.Status -eq '0xC0000225')
{
$FailureReason = 'Evidently a bug in Windows and not a risk'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $logonoff.Computer + ":::;" + $logonoff.SubjectUserSid + ":::;" + $logonoff.SubjectUserName + ":::;" + $logonoff.SubjectDomainName + ":::;" + $logonoff.SubjectLogonId + ":::;" + $logonoff.TargetUserSid + ":::;" + $logonoff.TargetUserName + ":::;" + $logonoff.TargetDomainName + ":::;" + ":::;" + $FailureReason + ":::;" + $logonoff.LogonType + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$FailureReason.Dispose()
}
elseif($logonoff.Status -eq '0xC0000234')
{
$FailureReason = 'User logon with account locked'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $logonoff.Computer + ":::;" + $logonoff.SubjectUserSid + ":::;" + $logonoff.SubjectUserName + ":::;" + $logonoff.SubjectDomainName + ":::;" + $logonoff.SubjectLogonId + ":::;" + $logonoff.TargetUserSid + ":::;" + $logonoff.TargetUserName + ":::;" + $logonoff.TargetDomainName + ":::;" + ":::;" + $FailureReason + ":::;" + $logonoff.LogonType + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$FailureReason.Dispose()
}
elseif($logonoff.Status -eq '0xC00002EE')
{
$FailureReason = 'An Error occured during Logon'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $logonoff.Computer + ":::;" + $logonoff.SubjectUserSid + ":::;" + $logonoff.SubjectUserName + ":::;" + $logonoff.SubjectDomainName + ":::;" + $logonoff.SubjectLogonId + ":::;" + $logonoff.TargetUserSid + ":::;" + $logonoff.TargetUserName + ":::;" + $logonoff.TargetDomainName + ":::;" + ":::;" + $FailureReason + ":::;" + $logonoff.LogonType + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$FailureReason.Dispose()
}
elseif($logonoff.Status -eq '0xC0000413')
{
$FailureReason = 'The specified account is not allowed to authenticate to this machine under the protection of authentication firewall'
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $log + ":::;" + $eventid + ":::;" + $datetime + ":::;" + $logonoff.Computer + ":::;" + $logonoff.SubjectUserSid + ":::;" + $logonoff.SubjectUserName + ":::;" + $logonoff.SubjectDomainName + ":::;" + $logonoff.SubjectLogonId + ":::;" + $logonoff.TargetUserSid + ":::;" + $logonoff.TargetUserName + ":::;" + $logonoff.TargetDomainName + ":::;" + ":::;" + $FailureReason + ":::;" + $logonoff.LogonType + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_logon.txt -Append -encoding utf8
$FailureReason.Dispose()
}

$log.Dispose()
}

$logonofflog.Dispose()
$PSObject.Dispose()
$datetime.Dispose()
$eventid.Dispose()
$logonoff.Dispose()
}

$sn.Dispose()
$mac.Dispose()
$ip.Dispose()
}

if ($job.State -eq "Completed")
{
Remove-Job $job
}
elseif ($job.State -eq "Running")
{
Sleep 10
}

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

$IP = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.netadapter.status -ne "Disconnected"}).ipv4address.ipaddress
$MAC = (Get-NetAdapter | where-object -FilterScript {$_.HardwareInterface -eq "True" -and $_.Status -ne "Disconnected"} | Where-Object {$_.InterfaceDescription -notmatch "TEST"}).MacAddress

$eextension = "nls", "dll", "mui", "clb", "ini", "ttc", "xml", "tmp", "log", "ldb", "edb-journal", "tlb", "deb", "json", "pages", "insertion", "css", "ar", "de", "otf", "svg", "js", "pt_PT", "zh_TW", "it", "fr", "en", "yahoo", `
"option", "woff", "ttf", "eot", "cat", "drv", "dat", "manifest", "sdb", "aym", "scd", "cdf-ms", "ico", "fon", "icm", "tingo", "compact", "config", "configuration", "core", "db", "pris", "pri", "web", "xam", "aye", "mta", "library-ms", "automaticDestinations-ms", "odf"

$eprocess = "C:\/Windows\/System32\/svchost.exe", "C:\/Program Files (x86)\/Google\/Update\/GoogleUpdate.exe", "C:\/Program Files (x86)\/INCAInternet\/nProtect Online Security\/nosstarter.npe", "C:\/program files (x86)\/markany\/webdrmnoax\/bin\/mawebdrmagent.exe", "C:\/Program Files (x86)\/NVIDIA Corporation\/Update Core\/NvTmMon.exe", "C:\/Program Files (x86)\/Realtek\/USB Wireless LAN Utility\/RtWLan.exe", "C:\/Program Files (x86)\/Western Digital\/Discovery\/Current\/WD Discovery.exe", "C:\/Program Files (x86)\/Western Digital\/WD Drive Manager\/WDDriveService.exe", "C:\/Program Files (x86)\/Wizvera\/Common\/wpmsvc\/wpmsvc.exe", "C:\/Program Files\/NVIDIA Corporation\/Display.NvContainer\/NVDisplay.Container.exe", "C:\/Program Files\/NVIDIA Corporation\/Display\/nvtray.exe", "C:\/Program Files\/WindowsApps\/microsoft.windowscommunicationsapps_17.8600.40525.0_x64__8wekyb3d8bbwe\/HxTsr.exe", "C:\/Windows\/System32\/conhost.exe", "C:\/Windows\/System32\/consent.exe", "C:\/Windows\/System32\/csrss.exe", "C:\/Windows\/System32\/DeviceCensus.exe", `
"C:\/Windows\/System32\/dllhost.exe", "C:\/Windows\/SysWOW64\/dllhost.exe", "C:\/Windows\/System32\/fontdrvhost.exe", "C:\/Windows\/SysWOW64\/fontdrvhost.exe", "C:\/Windows\/System32\/InputMethod\/CHS\/ChsIME.exe", "C:\/Windows\/System32\/lsass.exe", "C:\/Windows\/System32\/msfeedssync.exe", "C:\/Windows\/SysWOW64\/reg.exe", "C:\/Windows\/System32\/reg.exe", "C:\/Windows\/System32\/SearchFilterHost.exe", "C:\/Windows\/System32\/SearchIndexer.exe", "C:\/Windows\/System32\/Services.exe", "C:\/Windows\/SysWOW64\/services.exe", "C:\/Windows\/System32\/sihost.exe", "C:\/Windows\/System32\/smartscreen.exe", "C:\/Windows\/System32\/SppExtComObj.Exe", "C:\/Windows\/System32\/sppsvc.exe", "C:\/Windows\/System32\/taskhostw.exe", "C:\/Windows\/System32\/wbem\/WMIC.exe", "C:\/Windows\/System32\/wbem\/WmiPrvSE.exe", "C:\/Windows\/SysWOW64\/wbem\/WmiPrvSE.exe",`
"SearchUI.exe", "ShellExperienceHost.exe", "C:\/Program Files\/ESTsoft\/ALYac\/AYUpdSrv.aye", "C:\/Program Files\/ESTsoft\/ALYac\/AYAgent.aye", "C:\/Program Files (x86)\/Western Digital\/WD App Manager\/Plugins\/WD Backup\/App\/WDBackupService.exe", "C:\/Program Files\/Microsoft SQL Server\/MSSQL13.H\/MSSQL\/Binn\/sqlservr.exe", "C:\/Windows\/System32\/wermgr.exe", "C:\/Windows\/SysWOW64\/wermgr.exe", "C:\/Program Files\/ESTsoft\/ALYac\/AYRTSrv.aye", "C:\/Windows\/System32\/perfmon.exe", "C:\/Windows\/SysWOW64", "C:\/Program Files (x86)\/INCAInternet\/nProtect Online Security\/npUpdateC.exe", "C:\/Program Files\/ESTsoft\/ALYac\/ALNotice.exe", "C:\/Program Files (x86)\/Western Digital\/WD Utilities\/WDDriveUtilitiesHelper.exe",`
"C:\/Program Files (x86)\/Markany\/WebDRMNoAX\/bin\/MaWebDRMAgent.exe", "C:\/Windows\/System32\/Taskmgr.exe", "C:\/Windows\/System32\/services.exe", "C:\/Windows\/System32\/lsass.exe", "C:\/Program Files (x86)\/ESTsoft\/Common\/ALSTSCollector.exe", "C:\/Windows\/KMS-R@1nHook.exe",`
"C:\/Program Files (x86)\/NVIDIA Corporation\/NvContainer\/nvcontainer.exe", "C:\/Windows\/System32\/taskhostw.exe", "C:\/Windows\/System32\/wbem\/WmiPrvSE.exe", "C:\/Windows\/System32\/backgroundTaskHost.exe", "C:\/Windows\/SystemApps\/ShellExperienceHost_cw5n1h2txyewy\/ShellExperienceHost.exe", "C:\/Program Files (x86)\/ESTsoft\/ALUpdate\/ALUpProduct.exe", "C:\/Program Files\/KCP\/kcppayplugin.exe", "C:\/Windows\/System32\/WerFault.exe", "C:\/Windows\/System32\/winlogon.exe", "C:\/Program Files\/Microsoft SQL Server\/MSRS13.H\/Reporting Services\/ReportServer\/bin\/ReportingServicesService.exe",`
"C:\/Program Files\/Microsoft SQL Server\/MSSQL13.H\/MSSQL\/Binn\/Polybase\/mpdwsvc.exe", "C:\/Program Files\/Windows Defender\/MsMpEng.exe", "C:\/Program Files\/NVIDIA Corporation\/ShadowPlay\/nvspcaps64.exe", "C:\/Windows\/SoftwareDistribution\/Download\/Install\/NIS_Delta_Patch.exe", "C:\/Windows\/System32\/MpSigStub.exe", "C:\/Program Files (x86)\/INCAInternet\/nProtect Online Security\/npUpdateC.exe", "C:\/Program Files\/Realtek\/Audio\/HDA\/RAVCpl64.exe", "C:\/Windows\/System32\/RuntimeBroker.exe", "C:\/Windows\/System32\/mobsync.exe",`
"C:\/Program Files\/KCP\/kcppayplugin.exe", "C:\/Windows\/System32\/WerFault.exe", "C:\/Program Files (x86)\/INCAInternet\/nProtect Online Security\/nossvc.exe", "C:\/Windows\/System32\/dwm.exe", "C:\/Windows\/System32\/CompatTelRunner.exe", "C:\/Windows\/System32\/rundll32.exe", "C:\/Program Files (x86)\/Common Files\/Adobe\/AdobeGCClient\/AGSService.exe",`
"C:\/Windows\/System32\/InputMethod\/CHS\/ChsIME.exe", "C:\/Program Files\/WindowsApps\/Microsoft.Windows.Photos_2017.35071.16410.0_x64__8wekyb3d8bbwe\/Microsoft.Photos.exe", "C:\/Program Files\/NVIDIA Corporation\/NvContainer\/nvcontainer.exe", "C:\/Windows\/System32\/WindowsPowerShell\/v1.0\/powershell.exe", "C:\/Windows\/System32\/WindowsPowerShell\/v1.0\/Modules\/BitsTransfer", "C:\/Program Files\/ESTsoft\/ALYac\/AYHost.aye", "C:\/Windows\/System32\/WindowsPowerShell\/v1.0\/powershell_ise.exe",`
"C:\/Program Files\/ESTsoft\/ALYac\/AYPop.aye"

$dpath = "C:\"
$dpathnohidden = (Get-ChildItem -Path $dpath -recurse -Directory | select Fullname).FullName
$dpathhidden = (Get-ChildItem -Path $dpath -recurse -Directory -Hidden | select Fullname).FullName
$dpathhn = (Get-ChildItem -Path $dpathhidden -Recurse -Directory | select Fullname).FullName
$fpath = "C:\ProgramData\soalog", "C:\Windows\soa", "C:\Users\$env:username\AppData\Local\Kakao", "C:\Program Files (x86)\Kakao\KakaoTalk", "C:\Users\$env:username\AppData\Local\Google\Chrome\User Data"
$fpathout = (Get-ChildItem -Path $fpath -recurse -file | select Fullname).FullName
$fpathhout = (Get-ChildItem -Path $fpath -recurse -file -Hidden | select Fullname).FullName


get-winevent -FilterHashtable @{path = 'C:\ProgramData\soalog\*.evtx'; ID = 4656, 4659, 4660, 4662, 4663; data=$env:username} | foreach {
$oalog = [xml] $_.toxml()
$PSObject = New-Object PSObject
$datetime = $oalog.Event.System.TimeCreated.SystemTime.Split(".")[0]+"+09:00"
$eventid = $oalog.Event.System.EventID


$oa = "" | select ObjectType, ObjectServer, ObjectName, Computer, SubjectUserSid, SubjectUserName, SubjectLogonId, SubjectDomainName, AccessMask, AccessList, HandleID, ProcessName, AdditionalInfo2
$oalog.Event.EventData.Data | foreach {
$PSObject | Add-Member NoteProperty $_.Name $_."#text"
}

 $oa.ObjectType = $PSObject.ObjectType
        $oa.ObjectName = $PSObject.ObjectName
        $oa.ObjectServer = $PSObject.ObjectServer
        $oa.Computer = $PSObject.Computer
        $oa.SubjectUserSid = $PSObject.SubjectUserSid
        $oa.SubjectUserName = $PSObject.SubjectUserName
        $oa.SubjectLogonID = $PSObject.SubjectLogonID
        $oa.SubjectDomainName = $PSObject.SubjectDomainName
        $oa.AccessMask = $PSObject.AccessMask
        $oa.AccessList = $PSObject.AccessList
        $oa.HandleID = $PSObject.HandleID
        $oa.ProcessName = $PSObject.ProcessName
        $oa.ProcessName = $oa.ProcessName.Replace("\", "\/")
        $oa.AdditionalInfo2 = $PSObject.AdditionalInfo2
        

        $root = $oa.ObjectName.Split(":")[0]
        $file = $oa.ObjectName.Split("\")[-1]

         if ($oa.ObjectType -eq "File")
        {

        if ($oa.ObjectServer -eq "Security")
        {

        if ($oa.ProcessName |  where-object {$_ -notin $eprocess})
        {

        if ($objectname | Where-Object {$_ -notin $dpath, $dpathnohidden, $dpathhidden, $fpath, $fpathout, $fpathhout})
        {
        if($file | Where-Object {$_ -ne $null})
        {
        $directory = $oa.ObjectName.Split("\") |  select -SkipLast 1
        $directory = $directory -join '\/'

        $ext = $file.split(".")[-1]
       
        if ($ext | Where-Object {$_ -notin $eextension})
        {
            if ($file -eq $ext)
            {
            $next = $null
            
            if($oa.AccessMask -eq "0x1")
            {
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" +"ReadData (or ListDirectory)" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($oa.AccessMask -eq "0x2")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "WriteData (or AddFile)" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($oa.AccessMask -eq "0x4")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "AppendData (or AddSubdirectory)" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($oa.AccessMask -eq "0x40")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "DeleteChild" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($oa.AccessMask -eq "0x80")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "ReadAttributes" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($oa.AccessMask -eq "0x100")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "WriteAttributes" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($oa.AccessMask -eq "0x10000")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "DELETE" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($oa.AccessMask -eq "0x20000")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "READ_CONTROL" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($oa.AccessMask -eq "0x20")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "Execute (or Traverse)" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}

elseif($oa.AccessMask -eq "0x100000")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "Synchronize" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($oa.AccessMask -eq "0x200000")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "ReadControl" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($oa.AccessMask -eq "0x400000")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "WriteDAC" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($oa.AccessMask -eq "0x800000")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "WriteOwner" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $next + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
}

elseif ($file -ne $ext)
{
$ext = "."+$file.split(".")[-1]

if($oa.AccessMask -eq "0x1")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "ReadData (or ListDirectory)" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($oa.AccessMask -eq "0x2")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "WriteData (or AddFile)" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($oa.AccessMask -eq "0x4")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "AppendData (or AddSubdirectory)" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($oa.AccessMask -eq "0x40")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "DeleteChild" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($oa.AccessMask -eq "0x80")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "ReadAttributes" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($oa.AccessMask -eq "0x100")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "WriteAttributes" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($oa.AccessMask -eq "0x10000")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "DELETE" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($oa.AccessMask -eq "0x20000")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "READ_CONTROL" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}

elseif($oa.AccessMask -eq "0x20")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "FileExecute (or FileTraverse)" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($oa.AccessMask -eq "0x100000")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "Synchronize" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($oa.AccessMask -eq "0x200000")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "ReadControl" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($oa.AccessMask -eq "0x400000")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "WriteDAC" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
elseif($oa.AccessMask -eq "0x800000")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + "WriteOwner" + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $oa.ProcessName + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa.txt -Append -encoding utf8
}
}
}


}
}
}
}

elseif ($objectserver -match "MTP")
{
if($accessmask -eq "0x120116")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x120116","Write") + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $oa.AdditionalInfo2 + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa_mtp.txt -Append -encoding utf8
}
elseif($accessmask -eq "0x120089")
{
$sn + ":::;" + $ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x120089","READ") + ":::;" + $eventid + ":::;" + $oa.Computer + ":::;" + $oa.SubjectUserName + ":::;" + $datetime + ":::;" + $oa.SubjectUserSid + ":::;" + $oa.SubjectLogonID + ":::;" + $oa.SubjectDomainName + ":::;" + $oa.ObjectServer + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $oa.AdditionalInfo2 + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_oa_mtp.txt -Append -encoding utf8
}

}

$directory.Dispose()
$next.Dispose()
$ext.Dispose()

}
$root.Dispose()
$file.Dispose()
$eprocess.Dispose()
$PSObject.Dispose()
$datetime.Dispose()
$eventid.Dispose()
$oalog.Dispose()
$oa.Dispose()


$dpath.Dispose()
$dpathnohidden.Dispose()
$dpathhidden.Dispose()
$dpathhn.Dispose()
$fpathout.Dispose()
$fpathhout.Dispose()
$fpath.Dispose()

}
$eprocess.Dispose()
$eextension.Dispose()
$sn.Dispose()
$IP.Dispose()
$MAC.Dispose()



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
while (Test-Path $($_.FullName))
{
Remove-Item $($_.FullName)
skeeo 10
}
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
