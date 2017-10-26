$IP = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.netadapter.status -ne "Disconnected"}).ipv4address.ipaddress
$MAC = (Get-NetAdapter | where-object -FilterScript {$_.HardwareInterface -eq "True" -and $_.Status -ne "Disconnected"}).MacAddress
$events = get-winevent -FilterHashtable @{logname='security'; ID = 4663,4662,4656} -MaxEvents 3000 -Oldest | foreach {$_.toxml()}
foreach ($security in $events)
{
$security = $security.split("<")
$objecttype = $security | select-string -pattern 'ObjectType'
$objecttype = $objecttype.Line.split("=").split(">")[2]
if ($objecttype -eq "File")
{
$objectserver = $security | select-string -Pattern 'ObjectServer'
$objectserver = $objectserver.line.Split("=").split(">")[2]
if ($objectserver -eq "Security")
{
$objectname = $security | select-string -pattern 'ObjectName'
$objectname = $objectname.line.Split("=").split(">")[2]
$root = $objectname.split(":")[0]
$file = $objectname.Split("\")[-1]
$directory = $objectname.split("\") | select -SkipLast 1
$directory = $directory -join '\'
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
$ext = $file.split(".")[-1]
if ($file -eq $ext)
{
$next = $null
$directory = $directory+"\"+$file
if($accessmask -eq "0x1")
{
$ip + ":::;" + $MAC + ":::;" +"ReadData (or ListDirectory)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x2")
{
$ip + ":::;" + $MAC + ":::;" + "WriteData (or AddFile)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x4")
{
$ip + ":::;" + $MAC + ":::;" + "AppendData (or AddSubdirectory or CreatePipeInstance)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x40")
{
$ip + ":::;" + $MAC + ":::;" + "DeleteChild" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x80")
{
$ip + ":::;" + $MAC + ":::;" + "ReadAttributes" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x100")
{
$ip + ":::;" + $MAC + ":::;" + "WriteAttributes" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x10000")
{
$ip + ":::;" + $MAC + ":::;" + "DELETE" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x20000")
{
$ip + ":::;" + $MAC + ":::;" + "READ_CONTROL" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x2")
{
$ip + ":::;" + $MAC + ":::;" + "WriteData (or AddFile)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x20")
{
$ip + ":::;" + $MAC + ":::;" + "Execute (or Traverse)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x4")
{
$ip + ":::;" + $MAC + ":::;" + "AppendData (or AddSubdirectory)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x100000")
{
$ip + ":::;" + $MAC + ":::;" + "Synchronize" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x200000")
{
$ip + ":::;" + $MAC + ":::;" + "ReadControl" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x400000")
{
$ip + ":::;" + $MAC + ":::;" + "WriteDAC" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x800000")
{
$ip + ":::;" + $MAC + ":::;" + "WriteOwner" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
}
elseif ($file -ne $ext)
{
$ext = "."+$file.split(".")[-1]
if($accessmask -eq "0x1")
{
$ip + ":::;" + $MAC + ":::;" + "ReadData (or ListDirectory)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x2")
{
$ip + ":::;" + $MAC + ":::;" + "WriteData (or AddFile)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x4")
{
$ip + ":::;" + $MAC + ":::;" + "AppendData (or AddSubdirectory or CreatePipeInstance)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x40")
{
$ip + ":::;" + $MAC + ":::;" + "DeleteChild" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x80")
{
$ip + ":::;" + $MAC + ":::;" + "ReadAttributes" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x100")
{
$ip + ":::;" + $MAC + ":::;" + "WriteAttributes" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x10000")
{
$ip + ":::;" + $MAC + ":::;" + "DELETE" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x20000")
{
$ip + ":::;" + $MAC + ":::;" + "READ_CONTROL" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x2")
{
$ip + ":::;" + $MAC + ":::;" + "WriteData (or AddFile)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x20")
{
$ip + ":::;" + $MAC + ":::;" + "FileExecute (or FileTraverse)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x4")
{
$ip + ":::;" + $MAC + ":::;" +"AppendData (or AddSubdirectory)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x100000")
{
$ip + ":::;" + $MAC + ":::;" + "Synchronize" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x200000")
{
$ip + ":::;" + $MAC + ":::;" + "ReadControl" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x400000")
{
$ip + ":::;" + $MAC + ":::;" + "WriteDAC" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
if($accessmask -eq "0x800000")
{
$ip + ":::;" + $MAC + ":::;" + "WriteOwner" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_full.txt -Append -encoding utf8
}
}
elseif ($objectserver -match "MTP")
{
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
$ext = "."+$objectname.split(".")[-1]
$accessmask = $security | select-string -pattern 'AccessMask'
$accessmask = $accessmask.line.Split("=").split(">")[2]
$additionalinfo2 = $security | select-string -Pattern 'AdditionalInfo2'
$additionalinfo2 = $additionalinfo2.line.split("-").split(">")[1]
if($accessmask -eq "0x120116")
{
$ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x120116","Write") + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $objectname + ":::;" + $ext + ":::;" + $additionalinfo2 | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_oa_mtp.txt -Append -encoding utf8
}
if($accessmask -eq "0x120089")
{
$ip + ":::;" + $MAC + ":::;" + $accessmask.replace("0x120089","READ") + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $objectname + ":::;" + $ext + ":::;" + $additionalinfo2 | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_oa_mtp.txt -Append -encoding utf8
}
}
}
}
}
