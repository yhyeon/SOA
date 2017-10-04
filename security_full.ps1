get-winevent -FilterHashtable @{logname='security'; ID = 4663,4662,4656} -oldest| foreach {$_.toxml()}
foreach ($security in $events)
{$security = $security.split("<")
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
$domainname = $security | select-string -pattern 'SubjectDomainName'
$domainname = $domainname.line.Split("=").split(">")[2]
$objecttype = $security | select-string -pattern 'ObjectType'
$objecttype = $objecttype.line.Split("=").split(">")[2]
$objectname = $security | select-string -pattern 'ObjectName'
$objectname = $objectname.line.Split("=").split(">")[2]
$handleid = $security | select-string -pattern 'HandleId'
$handleid = $handleid.line.Split("=").split(">")[2]
$accesslist = $security | select-string -pattern 'AccessList'
$accesslist = $accesslist.line.Split("=").split(">").split("
				")[2]
$accessmask = $security | select-string -pattern 'AccessMask'
$accessmask = $accessmask.line.Split("=").split(">")[2]
$processid = $security | select-string -pattern 'ProcessId'
$processid = $processid.line.Split("=").split(">")[6]
$processname = $security | select-string -pattern 'ProcessName'
$processname = $processname.line.Split("=").split(">")[2]
$eventid + " : " + $time + " : " + $computer + " : " + $sid + " : " + $username + " : " + $domainname + " : " + $objectserver + " : " + $objecttype + " : " + $objectname + " : " + $handleid + " : " + $accesslist + " : " + $accessmask + " : " + $processid + " : " + $processname | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhhmm)_security.txt -Append }
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
$domainname = $security | select-string -pattern 'SubjectDomainName'
$domainname = $domainname.line.Split("=").split(">")[2]
$objecttype = $security | select-string -pattern 'ObjectType'
$objecttype = $objecttype.line.Split("=").split(">")[2]
$objectname = $security | select-string -pattern 'ObjectName'
$objectname = $objectname.line.Split("=").split(">")[2]
$operationtype = $security | select-string -pattern 'OperationType'
$operationtype = $operationtype.line.Split("=").split(">")[2]
$handleid = $security | select-string -pattern 'HandleId'
$handleid = $handleid.line.Split("=").split(">")[2]
$accesslist = $security | select-string -pattern 'AccessList'
$accesslist = $accesslist
$accesslist = $accesslist.line.Split("=").split(">").split("





")
$accesslist = $accesslist[2]+$accesslist[4]+$accesslist[6]+$accesslist[8]+$accesslist[10]+$accesslist[12]
$accessmask = $security | select-string -pattern 'AccessMask'
$accessmask = $accessmask.line.Split("=").split(">")[2]
$additionalinfo = $security | select-string -Pattern 'AdditionalInfo'
$additionalinfo = $additionalinfo.line.split("-").split(">")[1]
$additionalinfo2 = $security | select-string -Pattern 'AdditionalInfo2'
$additionalinfo2 = $additionalinfo2.line.split("-").split(">")[1]
$eventid + " : " + $time + " : " + $computer + " : " + $sid + " : " + $username + " : " + $domainname + " : " + $objectserver + " : " + $objecttype + " : " + $operationtype + " : " + $handleid + " : " + $accesslist + " : " + $accessmask + " : " + $additionalinfo + " : " + $additionalinfo2 | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhhmm)_security.txt -Append}
}
