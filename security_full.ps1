$events = get-winevent -FilterHashtable @{logname='security'; ID = 4663,4662,4656} -oldest | foreach {$_.toxml()}
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
$eventid = $security | select-string -pattern 'EventID'
$eventid = $eventid.line.split(">")[1]
$time = $security | select-string -pattern 'TimeCreated'
$time = [datetime]($time.line.split("=").split("/>").split("'")[2])
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
$processname = $security | select-string -pattern 'ProcessName'
$processname = $processname.line.Split("=").split(">")[2]
if($accessmask -eq "0x1")
{
$accessmask.replace("0x1","ReadData (or ListDirectory)") + " : " + $eventid + " : " + $time + " : " + $computer + " : " + $sid + " : " + $username + " : " + $logonid + " : " + $domainname + " : " + $objectserver + " : " + $objectname + " : " + $processname | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_security.txt -Append
}
if($accessmask -eq "0x2")
{
$accessmask.replace("0x2","WriteData (or AddFile)") + " : " + $eventid + " : " + $time + " : " + $computer + " : " + $sid + " : " + $username + " : " + $logonid + " : " + $domainname + " : " + $objectserver + " : " + $objectname + " : " + $processname| out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_security.txt -Append
}
if($accessmask -eq "0x4")
{
$accessmask.replace("0x4","AppendData (or AddSubdirectory or CreatePipeInstance)") + " : " + $eventid + " : " + $time + " : " + $computer + " : " + $sid + " : " + $username + " : " + $logonid + " : " + $domainname + " : " + $objectserver + " : " + $objectname + " : " + $processname | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_security.txt -Append
}
if($accessmask -eq "0x40")
{
$accessmask.replace("0x40","DeleteChild") + " : " + $eventid + " : " + $time + " : " + $computer + " : " + $sid + " : " + $username + " : " + $logonid + " : " + $domainname + " : " + $objectserver + " : " + $objectname + " : " + $processname | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_security.txt -Append
}
if($accessmask -eq "0x80")
{
$accessmask.replace("0x80","ReadAttributes") + " : " + $eventid + " : " + $time + " : " + $computer + " : " + $sid + " : " + $username + " : " + $logonid + " : " + $domainname + " : " + $objectserver + " : " + $objectname + " : " + $processname | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_security.txt -Append
}
if($accessmask -eq "0x100")
{
$accessmask.replace("0x100","WriteAttributes") + " : " + $eventid + " : " + $time + " : " + $computer + " : " + $sid + " : " + $username + " : " + $logonid + " : " + $domainname + " : " + $objectserver + " : " + $objectname + " : " + $processname | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_security.txt -Append
}
if($accessmask -eq "0x10000")
{
$accessmask.replace("0x10000","DELETE") + " : " + $eventid + " : " + $time + " : " + $computer + " : " + $sid + " : " + $username + " : " + $logonid + " : " + $domainname + " : " + $objectserver + " : " + $objectname + " : " + $processname | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_security.txt -Append
}
if($accessmask -eq "0x20000")
{
$accessmask.replace("0x20000","READ_CONTROL") + " : " + $eventid + " : " + $time + " : " + $computer + " : " + $sid + " : " + $username + " : " + $logonid + " : " + $domainname + " : " + $objectserver + " : " + $objectname + " : " + $processname | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_security.txt -Append
}
}
elseif ($objectserver -match "MTP")
{
$eventrecordid = $security | select-string -pattern 'EventRecordID>'
$eventrecordid = $eventrecordid.line.trim("/*")
$eventid = $security | select-string -pattern 'EventID'
$eventid = $eventid.line.split(">")[1]
$time = $security | select-string -pattern 'TimeCreated'
$time = [datetime]($time.line.split("=").split("/>").split("'")[2])
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
$accessmask.replace("0x120116","Write") + " : " + $eventid + " : " + $time + " : " + $computer + " : " + $sid + " : " + $username + " : " + $logonid + " : " + $domainname + " : " + $objectserver + " : " + $objectname + " : " + $additionalinfo2  | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_security_mtp.txt -Append
}
if($accessmask -eq "0x120089")
{
$accessmask.replace("0x120089","READ") + " : " + $eventid + " : " + $time + " : " + $computer + " : " + $sid + " : " + $username + " : " + $logonid + " : " + $domainname + " : " + $objectserver + " : " + $objectname + " : " +  $additionalinfo2  | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_security_mtp.txt -Append
}
}
}
}
