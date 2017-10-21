$ErrorActionPreference = 'silentlycontinue'
$IP = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.netadapter.status -ne "Disconnected"}).ipv4address.ipaddress
$MAC = (Get-NetAdapter | where-object -FilterScript {$_.HardwareInterface -eq "True" -and $_.Status -ne "Disconnected"}).MacAddress
$events = get-winevent -FilterHashtable @{logname='security'; ID = 4624, 528, 540, 4648, 552, 4634, 538, 4647, 551, 4608, 512, 4625, 529, 530, 531, 532, 533, 534, 536, 537, 539} | foreach {$_.toxml()}
foreach ($logon in $events)
{$logon = $logon.split("<")
$eventid = $logon | select-string -pattern 'EventID'
$eventid = $eventid.line.split(">")[1]

if (($eventid -eq "4624") -or ($eventid -eq "528") -or ($eventid -eq "540"))
{
$log = 'An account was successfully logged on'
$datetime = $logon | select-string -pattern 'TimeCreated'
$datetime = [datetime]($datetime.line.split("=").split("/>").split("'")[2])
$datetime = get-date $datetime -format yyyy-MM-dd@HH:mm:ss
$date = $datetime.Split("@")[0]
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
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
elseif (($eventid -eq "4648") -or ($eventid -eq "552"))
{
$log = 'A logon was attempted using explicit credentials'
$datetime = $logon | select-string -pattern 'TimeCreated'
$datetime = [datetime]($datetime.line.split("=").split("/>").split("'")[2])
$datetime = get-date $datetime -format yyyy-MM-dd@HH:mm:ss
$date = $datetime.Split("@")[0]
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
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
elseif (($eventid -eq "4634") -or ($eventid -eq "538"))
{
$log = 'An account was logged off'
$datetime = $logon | select-string -pattern 'TimeCreated'
$datetime = [datetime]($datetime.line.split("=").split("/>").split("'")[2])
$datetime = get-date $datetime -format yyyy-MM-dd@HH:mm:ss
$date = $datetime.Split("@")[0]
$time = $datetime.Split("@")[1]
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
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" +  ":::;" +  ":::;" +  ":::;" +  ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + $targetlogonid+ ":::;" | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
elseif (($eventid -eq "4647") -or ($eventid -eq "551"))
{
$log = 'User initiated logoff'
$datetime = $logon | select-string -pattern 'TimeCreated'
$datetime = [datetime]($datetime.line.split("=").split("/>").split("'")[2])
$datetime = get-date $datetime -format yyyy-MM-dd@HH:mm:ss
$date = $datetime.Split("@")[0]
$time = $datetime.Split("@")[1]
$computer = $logon | select-string -pattern 'Computer'
$computer = $computer.line.split(">")[1]
$targetsid = $logon | select-string -Pattern 'TargetUserSid'
$targetsid = $targetsid.line.Split(">")[1]
$targetuname = $logon | select-string -Pattern 'TargetUserName'
$targetuname = $targetuname.line.Split(">")[1]
$targetdname = $logon | select-string -Pattern 'TargetDomainName'
$targetdname = $targetdname.line.Split(">")[1]
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + ":::;" + ":::;" + ":::;" + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
elseif (($eventid -eq "4608") -or ($eventid -eq "512"))
{
$log = 'Windows is starting up'
$datetime = $logon | select-string -pattern 'TimeCreated'
$datetime = [datetime]($datetime.line.split("=").split("/>").split("'")[2])
$datetime = get-date $datetime -format yyyy-MM-dd@HH:mm:ss
$date = $datetime.Split("@")[0]
$time = $datetime.Split("@")[1]
$computer = $logon | select-string -pattern 'Computer'
$computer = $computer.line.split(">")[1]
$targetsid = $logon | select-string -Pattern 'TargetUserSid'
$targetsid = $targetsid.line.Split(">")[1]
$targetuname = $logon | select-string -Pattern 'TargetUserName'
$targetuname = $targetuname.line.Split(">")[1]
$targetdname = $logon | select-string -Pattern 'TargetDomainName'
$targetdname = $targetdname.line.Split(">")[1]
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + ":::;" + ":::;" +  ":::;" +  ":::;" + ":::;" +  ":::;" +  ":::;" + ":::;" | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
elseif (($eventid -eq "4625") -or ($eventid -eq "529") -or ($eventid -eq "530") -or ($eventid -eq "531") -or ($eventid -eq "532") -or ($eventid -eq "533") -or ($eventid -eq "534") -or ($eventid -eq "535") -or ($eventid -eq "536") -or ($eventid -eq "537") -or ($eventid -eq "539"))
{
$log = 'An account failed to log on'
$datetime = $logon | select-string -pattern 'TimeCreated'
$datetime = [datetime]($datetime.line.split("=").split("/>").split("'")[2])
$datetime = get-date $datetime -format yyyy-MM-dd@HH:mm:ss
$date = $datetime.Split("@")[0]
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
$targetsid = $logon | select-string -Pattern 'TargetUserSid'
$targetsid = $targetsid.line.Split(">")[1]
$targetuname = $logon | select-string -Pattern 'TargetUserName'
$targetuname = $targetuname.line.Split(">")[1]
$targetdname = $logon | select-string -Pattern 'TargetDomainName'
$targetdname = $targetdname.line.Split(">")[1]
$failurestatus = $logon | select-string -Pattern 'FailureReason'
$failurestatus = $failurestatus.line.Split(">")[1]
if($failurestatus -eq '0XC000005E')
{
$failurecode = 'Currently no logon servers available'
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failuecode | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC0000064')
{
$failurecode = 'User logon with misspelled or bad user account '
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failuecode | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC000006A')
{
$failurecode = 'User logon with misspelled or bad password'
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failuecode | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0XC000006D')
{
$failurecode = 'Either due to a bad username or authentication information'
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failuecode | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0XC000006E')
{
$failurecode = 'Unknown user name or bad password'
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failuecode | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC000006F')
{
$failurecode = 'User logon outside authorized hours'
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failuecode | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC0000070')
{
$failurecode = 'User logon from unauthroized workstation'
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failuecode | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC0000071')
{
$failurecode = 'User logon with expired password'
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failuecode | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC0000072')
{
$failurecode = 'User logon to account disabled by administrator'
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failuecode | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC00000DC')
{
$failurecode = 'Sam Server was in the wrong state to perform the desired operation'
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failuecode  | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC0000133')
{
$failurecode = 'Clocks between DC and other computer too far out of sync'
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failuecode  | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC000015B')
{
$failurecode = 'The user has not been granted the requested logon right at this machine'
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failuecode | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC000018C')
{
$failurecode = 'Due to the trust relationship between the primary domain and the trusted domain failed'
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failuecode | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC0000192')
{
$failurecode = 'Netlogon service was not started'
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failuecode | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC0000193')
{
$failurecode = 'User logon with expired account'
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failuecode | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC0000224')
{
$failurecode = 'User is required to change password at next logon'
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $time + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failuecode | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC0000225')
{
$failurecode = 'Evidently a bug in Windows and not a risk'
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failuecode | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC0000234')
{
$failurecode = 'User logon with account locked'
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failuecode | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC00002EE')
{
$failurecode = 'An Error occured during Logon'
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failuecode | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
elseif($failurestatus -eq '0xC0000413')
{
$failurecode = 'The specified account is not allowed to authenticate to this machine under the protection of authentication firewall'
$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $log + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $subjectsid + ":::;" + $subjectuname + ":::;" + $subjectdname + ":::;" + $subjectlogonid + ":::;" + $targetsid + ":::;" + $targetuname + ":::;" + $targetdname + ":::;" + ":::;" + $failuecode | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_logonoff.txt -Append -encoding utf8
}
}
}
