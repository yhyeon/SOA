$events = get-winevent -FilterHashtable @{logname='security'; ID = 4663,4662,4656} | foreach {$_.toxml()}
$eprocess = "mmc.exe|svchost.exe|GoogleUpdate.exe|nosstarter.npe|MaWebDRMAgent.exe|NvTmMon.exe|RtWLan.exe|Wd Discovery.exe|WdDriveService.exe|wpmsvc.exe|NVDisplay.Container.exe|nvtray.exe|HxTsr.exe|conhost.exe|consent.exe|csrss.exe|DeviceCensus.exe|dllhost.exe|fontdrvhost.exe|ChsIME.exe|Iass.exe|mmc.exe|msfeedssync.exe|reg.exe|SearchFilterHost.exe|SearchIndexcer.exe|Services.exe|sihost.exe|smartscreen.exe|sppExtComObj.Exe|sppsvc.exe|svchost.exe|taskhostw.exe|WMIC.exe|WmiPrvSE.exe|SearchUI.exe|ShellExperienceHost.exe|AYUpdSrv.aye|AYAgent.aye|WDBackupService.exe|sqlservr.exe|SearchIndexer.exe"
$eextension = ".nls|.dll|.mui|.clb|.ini|.ttc|.xml|.tmp|.log|.ldb|.edb-journal|.tlb|.deb"
$directoryonly = "C:\|C:\Users|C:\Program Files|C:\Program Files (x86)|C:\ProgramData\Microsoft|C:\ProgramData\Microsoft\Windows|C:\Users\*\AppData|C:\Users\*\AppData\Local|C:\Users\*\AppData\Local\Google"
foreach ($security in $events)
{$security = $security.split("<")
$objecttype = $security | select-string -pattern 'ObjectType'
$objecttype = $objecttype.line.Split("=").split(">")[2]
$processname = $security | select-string -pattern 'ProcessName'
$processname = $processname.line.Split("=").split(">")[2]
if ($processname | where-object {$_ -notmatch $eprocess})
{
$objectname = $security | select-string -pattern 'ObjectName'
$objectname = $objectname.line.Split("=").split(">")[2]
if ($objectname | where-object {$_ -notmatch $eextension} )
{
if ($objecttype -eq "File")
{
$objectserver = $security | select-string -Pattern 'ObjectServer'
$objectserver = $objectserver.line.Split("=").split(">")[2]
if ($objectserver -eq "Security")
{
$eventid = $security | select-string -pattern 'EventID'
$eventid = $eventid.line.split(">")[1]
$datetime = $security | select-string -pattern 'TimeCreated'
$datetime = [datetime]($datetime.line.split("=").split("/>").split("'")[2])
$datetime = get-date $datetime -format yyyy-MM-dd@hh:mm:ss
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
if($accessmask -eq "0x1")
{
$accessmask.replace("0x1","ReadData (or ListDirectory)") + " : " + $eventid + " : " + $date + " : " + $time + " : " + $computer + " : " + $sid + " : " + $username + " : " + $logonid + " : " + $domainname + " : " + $objectserver + " : " + $objectname + " : " + $processname | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_oa.txt -Append -Encoding utf8
}
if($accessmask -eq "0x2")
{
$accessmask.replace("0x2","WriteData (or AddFile)") + " : " + $eventid + " : " + $date + " : " + $time + " : " + $computer + " : " + $sid + " : " + $username + " : " + $logonid + " : " + $domainname + " : " + $objectserver + " : " + $objectname + " : " + $processname| out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_oa.txt -Append -Encoding utf8
}
if($accessmask -eq "0x4")
{
$accessmask.replace("0x4","AppendData (or AddSubdirectory or CreatePipeInstance)") + " : " + $eventid + " : " + $date + " : " + $time + " : " + $computer + " : " + $sid + " : " + $username + " : " + $logonid + " : " + $domainname + " : " + $objectserver + " : " + $objectname + " : " + $processname | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_oa.txt -Append -Encoding utf8
}
if($accessmask -eq "0x40")
{
$accessmask.replace("0x40","DeleteChild") + " : " + $eventid + " : " + $date + " : " + $time + " : " + $computer + " : " + $sid + " : " + $username + " : " + $logonid + " : " + $domainname + " : " + $objectserver + " : " + $objectname + " : " + $processname | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_oa.txt -Append -Encoding utf8
}
if($accessmask -eq "0x80")
{
$accessmask.replace("0x80","ReadAttributes") + " : " + $eventid + " : " + $date + " : " + $time + " : " + $computer + " : " + $sid + " : " + $username + " : " + $logonid + " : " + $domainname + " : " + $objectserver + " : " + $objectname + " : " + $processname | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_oa.txt -Append -Encoding utf8
}
if($accessmask -eq "0x100")
{
$accessmask.replace("0x100","WriteAttributes") + " : " + $eventid + " : " + $date + " : " + $time + " : " + $computer + " : " + $sid + " : " + $username + " : " + $logonid + " : " + $domainname + " : " + $objectserver + " : " + $objectname + " : " + $processname | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_oa.txt -Append -Encoding utf8
}
if($accessmask -eq "0x10000")
{
$accessmask.replace("0x10000","DELETE") + " : " + $eventid + " : " + $date + " : " + $time + " : " + $computer + " : " + $sid + " : " + $username + " : " + $logonid + " : " + $domainname + " : " + $objectserver + " : " + $objectname + " : " + $processname | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_oa.txt -Append -Encoding utf8
}
if($accessmask -eq "0x20000")
{
$accessmask.replace("0x20000","READ_CONTROL") + " : " + $eventid + " : " + $date + " : " + $time + " : " + $computer + " : " + $sid + " : " + $username + " : " + $logonid + " : " + $domainname + " : " + $objectserver + " : " + $objectname + " : " + $processname | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_oa.txt -Append -Encoding utf8
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
$datetime = get-date $datetime -format yyyy-MM-dd@hh:mm:ss
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
$additionalinfo2 = $security | select-string -Pattern 'AdditionalInfo2'
$additionalinfo2 = $additionalinfo2.line.split("-").split(">")[1]
if($accessmask -eq "0x120116")
{
$accessmask.replace("0x120116","Write") + " : " + $eventid + " : " + $date + " : " + $time + " : " + $computer + " : " + $sid + " : " + $username + " : " + $logonid + " : " + $domainname + " : " + $objectserver + " : " + $objectname + " : " + $additionalinfo2  | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_security_mtp.txt -Append -Encoding utf8
}
if($accessmask -eq "0x120089")
{
$accessmask.replace("0x120089","READ") + " : " + $eventid + " : " + $date + " : " + $time + " : " + $computer + " : " + $sid + " : " + $username + " : " + $logonid + " : " + $domainname + " : " + $objectserver + " : " + $objectname + " : " + $additionalinfo2  | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhh)_security_mtp.txt -Append -Encoding utf8
}
}
}
}
}
}