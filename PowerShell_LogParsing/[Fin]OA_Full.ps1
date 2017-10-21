$IP = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.netadapter.status -ne "Disconnected"}).ipv4address.ipaddress
$MAC = (Get-NetAdapter | where-object -FilterScript {$_.HardwareInterface -eq "True" -and $_.Status -ne "Disconnected"}).MacAddress
$events = get-winevent -FilterHashtable @{logname='security'; ID = 4663,4662,4656} | foreach {$_.toxml()}
foreach ($security in $events)
{$security = $security.split("<")
$objecttype = $security | select-string -pattern 'ObjectType'
$objecttype = $objecttype.line.Split("=").split(">")[2]
if ($objecttype -eq "File")
{
$objectserver = $security | select-string -Pattern 'ObjectServer'
$objectserver = $objectserver.line.Split("=").split(">")[2]
if ($objectserver -eq "Security")
{
$objectname = $security | select-string -pattern 'ObjectName'
$objectname = $objectname.line.Split("=").split(">")[2]
$eventid = $security | select-string -pattern 'EventID'
$eventid = $eventid.line.split(">")[1]
$datetime = $security | select-string -pattern 'TimeCreated'
$datetime = [datetime]($datetime.line.split("=").split("/>").split("'")[2])
$datetime = get-date $datetime -format yyyy-MM-dd@HH:mm:ss
$date = $datetime.Split("@")[0]
$time = $datetime.Split("@")[1]
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
$processname = $security | select-string -pattern 'ProcessName'
$processname = $processname.line.Split("=").split(">")[2]
if($accessmask -eq "0x1")
{
$ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x1","ReadData (or ListDirectory)") + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $objectname + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_security.txt -Append -encoding utf8
}
if($accessmask -eq "0x2")
{
$ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x2","WriteData (or AddFile)") + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $mac + ":::;" + $sid + ":::;" + $username + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $objectname + ":::;" + $processname| out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_security.txt -Append -encoding utf8
}
if($accessmask -eq "0x4")
{
$ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x4","AppendData (or AddSubdirectory or CreatePipeInstance)") + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $mac + ":::;" + $sid + ":::;" + $username + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $objectname + ":::;" + $processname | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_security.txt -Append -encoding utf8
}
if($accessmask -eq "0x40")
{
$ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x40","DeleteChild") + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $mac + ":::;" + $sid + ":::;" + $username + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $objectname + ":::;" + $processname | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_security.txt -Append -encoding utf8
}
if($accessmask -eq "0x80")
{
$ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x80","ReadAttributes") + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $mac + ":::;" + $sid + ":::;" + $username + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $objectname + ":::;" + $processname | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_security.txt -Append -encoding utf8
}
if($accessmask -eq "0x100")
{
$ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x100","WriteAttributes") + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $mac + ":::;" + $sid + ":::;" + $username + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $objectname + ":::;" + $processname | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_security.txt -Append -encoding utf8
}
if($accessmask -eq "0x10000")
{
$ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x10000","DELETE") + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $mac + ":::;" + $sid + ":::;" + $username + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $objectname + ":::;" + $processname | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_oanf.txt -Append -encoding utf8
}
if($accessmask -eq "0x20000")
{
$ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x20000","READ_CONTROL") + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $mac + ":::;" + $sid + ":::;" + $username + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $objectname + ":::;" + $processname | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_oanf.txt -Append -encoding utf8
}
}
elseif ($objectserver -match "MTP")
{
$eventrecordid = $security | select-string -pattern 'EventRecordID>'
$eventrecordid = $eventrecordid.line.trim("/*")
$eventid = $security | select-string -pattern 'EventID'
$eventid = $eventid.line.split(">")[1]
$datetime = $security | select-string -pattern 'TimeCreated'
$datetime = [datetime]($datetime.line.split("=").split("/>").split("'")[2])
$datetime = get-date $datetime -format yyyy-MM-dd@HH:mm:ss
$date = $datetime.Split("@")[0]
$time = $datetime.Split("@")[1]
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
$accessmask = $security | select-string -pattern 'AccessMask'
$accessmask = $accessmask.line.Split("=").split(">")[2]
$additionalinfo2 = $security | select-string -Pattern 'AdditionalInfo2'
$additionalinfo2 = $additionalinfo2.line.split("-").split(">")[1]
if($accessmask -eq "0x120116")
{
$ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x120116","Write") + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $mac + ":::;" + $sid + ":::;" + $username + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $objectname + ":::;" + $additionalinfo2  | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_oa_mtp.txt -Append -encoding utf8
}
if($accessmask -eq "0x120089")
{
$ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x120089","READ") + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $mac + ":::;" + $sid + ":::;" + $username + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $objectname + ":::;" +  $additionalinfo2  | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_oa_mtp.txt -Append -encoding utf8
}
}
}
}
{
$objectserver = $security | select-string -Pattern 'ObjectServer'
$objectserver = $objectserver.line.Split("=").split(">")[2]
if ($objectserver -eq "Security")
{
$objectname = $security | select-string -pattern 'ObjectName'
$objectname = $objectname.line.Split("=").split(">")[2]
$eventid = $security | select-string -pattern 'EventID'
$eventid = $eventid.line.split(">")[1]
$datetime = $security | select-string -pattern 'TimeCreated'
$datetime = [datetime]($datetime.line.split("=").split("/>").split("'")[2])
$datetime = get-date $datetime -format yyyy-MM-dd@HH:mm:ss
$date = $datetime.Split("@")[0]
$time = $datetime.Split("@")[1]
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
$processname = $security | select-string -pattern 'ProcessName'
$processname = $processname.line.Split("=").split(">")[2]
if($accessmask -eq "0x1")
{
$ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x1","ReadData (or ListDirectory)") + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $mac + ":::;" + $sid + ":::;" + $username + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $objectname + ":::;" + $processname | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_security.txt -Append -encoding utf8
}
if($accessmask -eq "0x2")
{
$ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x2","WriteData (or AddFile)") + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $mac + ":::;" + $sid + ":::;" + $username + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $objectname + ":::;" + $processname| out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_security.txt -Append -encoding utf8
}
if($accessmask -eq "0x4")
{
$ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x4","AppendData (or AddSubdirectory or CreatePipeInstance)") + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $mac + ":::;" + $sid + ":::;" + $username + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $objectname + ":::;" + $processname | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_security.txt -Append -encoding utf8
}
if($accessmask -eq "0x40")
{
$ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x40","DeleteChild") + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $mac + ":::;" + $sid + ":::;" + $username + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $objectname + ":::;" + $processname | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_security.txt -Append -encoding utf8
}
if($accessmask -eq "0x80")
{
$ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x80","ReadAttributes") + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $mac + ":::;" + $sid + ":::;" + $username + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $objectname + ":::;" + $processname | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_security.txt -Append -encoding utf8
}
if($accessmask -eq "0x100")
{
$ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x100","WriteAttributes") + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $mac + ":::;" + $sid + ":::;" + $username + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $objectname + ":::;" + $processname | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_security.txt -Append -encoding utf8
}
if($accessmask -eq "0x10000")
{
$ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x10000","DELETE") + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $mac + ":::;" + $sid + ":::;" + $username + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $objectname + ":::;" + $processname | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_security.txt -Append -encoding utf8
}
if($accessmask -eq "0x20000")
{
$ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x20000","READ_CONTROL") + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $mac + ":::;" + $sid + ":::;" + $username + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $objectname + ":::;" + $processname | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_security.txt -Append -encoding utf8
}
}
elseif ($objectserver -match "MTP")
{
$eventrecordid = $security | select-string -pattern 'EventRecordID>'
$eventrecordid = $eventrecordid.line.trim("/*")
$eventid = $security | select-string -pattern 'EventID'
$eventid = $eventid.line.split(">")[1]
$datetime = $security | select-string -pattern 'TimeCreated'
$datetime = [datetime]($datetime.line.split("=").split("/>").split("'")[2])
$datetime = get-date $datetime -format yyyy-MM-dd@HH:mm:ss
$date = $datetime.Split("@")[0]
$time = $datetime.Split("@")[1]
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
$accessmask = $security | select-string -pattern 'AccessMask'
$accessmask = $accessmask.line.Split("=").split(">")[2]
$additionalinfo2 = $security | select-string -Pattern 'AdditionalInfo2'
$additionalinfo2 = $additionalinfo2.line.split("-").split(">")[1]
if($accessmask -eq "0x120116")
{
$ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x120116","Write") + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $mac + ":::;" + $sid + ":::;" + $username + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $objectname + ":::;" + $additionalinfo2  | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_security_mtp.txt -Append -encoding utf8
}
if($accessmask -eq "0x120089")
{
$ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x120089","READ") + ":::;" + $eventid + ":::;" + $date + ":::;" + $time + ":::;" + $computer + ":::;" + $mac + ":::;" + $sid + ":::;" + $username + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $objectname + ":::;" +  $additionalinfo2  | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_security_mtp.txt -Append -encoding utf8
}
}
}
