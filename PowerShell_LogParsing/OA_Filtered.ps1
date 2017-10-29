$sw = [System.Diagnostics.Stopwatch]::startnew()
$IP = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.netadapter.status -ne "Disconnected"}).ipv4address.ipaddress
$MAC = (Get-NetAdapter | where-object -FilterScript {$_.HardwareInterface -eq "True" -and $_.Status -ne "Disconnected"}).MacAddress
$log = Get-WmiObject -Class win32_NTeventlogfile 
$events = get-winevent -FilterHashtable @{logname='security'; ID = 4656, 4659, 4660, 4662, 4663} -MaxEvents 100000 | foreach {$_.toxml()}
$eprocess = "svchost.exe|GoogleUpdate.exe|nosstarter.npe|MaWebDRMAgent.exe|NvTmMon.exe|RtWLan.exe|Wd Discovery.exe|WdDriveService.exe|wpmsvc.exe|NVDisplay.Container.exe|nvtray.exe|HxTsr.exe|conhost.exe|consent.exe|csrss.exe|DeviceCensus.exe|dllhost.exe|fontdrvhost.exe|ChsIME.exe|Iass.exe|msfeedssync.exe|reg.exe|SearchFilterHost.exe|SearchIndexcer.exe|Services.exe|sihost.exe|smartscreen.exe|sppExtComObj.Exe|sppsvc.exe|svchost.exe|taskhostw.exe|WMIC.exe|WmiPrvSE.exe|SearchUI.exe|ShellExperienceHost.exe|AYUpdSrv.aye|AYAgent.aye|WDBackupService.exe|sqlservr.exe|SearchIndexer.exe|lsass.exe|wermgr.exe|ayrtsrv.aye|perfmon.exe|npUpdateC.exe"
$eextension = ".nls|.dll|.mui|.clb|.ini|.ttc|.xml|.tmp|.log|.ldb|.edb-journal|.tlb|.deb|.json|.pages|.insertion|.css|.ar|.de|.otf|.svg|.js|.pt_PT|.zh_TW|.it|.fr|.en|.yahoo|.option|.woff|.ttf|.eot|.html|.cat|.drv|.dat|.manifest|.sdb|.aym|.scd|.cdf-ms|.ico|.fon"
$directoryonly = "C:\|C:\Users|C:\Program Files|C:\Program Files (x86)|C:\ProgramData\Microsoft|C:\ProgramData\Microsoft\Windows|C:\Users\*\AppData|C:\Users\*\AppData\Local|C:\Users\*\AppData\Local\Google\*|;C:\Users\*\AppData\Local\Google\Chrome\User Data|C:\Program Files (x86)\Google\Chrome\Application|C:\Program Files (x86)\Kakao\KakaoTalk\*|C:\Users\*\AppData\Local\Kakao\KakaoTalk|C:\Users\*\IntelGraphicsProfiles\*|C:\Windows\WinSxS|C:\Windows|C:\Program Files\7-Zip|C:\Program Files\Bandizip\*|C:\Program Files\ESTsoft\ALYac|C:\Windows\System32|C:\Program Files (x86)\ESTsoft\ALCapture|C:\Program Files (x86)\Kakao\KakaoTalk|C:\Program Files\NVIDIA Corporation\Display.NvContainer|C:\Program Files\Realtek\Audio\HDA|C:\Program Files (x86)\Wizvera\Veraport20|C:\Windows\SysWOW64|C:\Program Files (x86)\Wizvera\Common\wpmsvc|C:\Program Files\WindowsApps|C:\Windows\System32\wbem"
foreach ($security in $events)
{$security = $security.split("<")
$objecttype = $security | select-string -pattern 'ObjectType'
$objecttype = $objecttype.line.Split("=").split(">")[2]
$objectserver = $security | select-string -Pattern 'ObjectServer'
$objectserver = $objectserver.line.Split("=").split(">")[2]
if ($objectserver -eq "Security")
{
$processname = $security | select-string -pattern 'ProcessName'
$processname = $processname.line.Split("=").split(">")[2]
if ($processname | where-object {$_ -notmatch $eprocess})
{
$objectname = $security | select-string -pattern 'ObjectName'
$objectname = $objectname.line.Split("=").split(">")[2]
if ($objectname | where-object {$_ -notmatch $eextension})
{
if ($objecttype -eq "File")
{
$root = $objectname.split(":")[0]
$file = $objectname.Split("\")[-1]
if($file | where-object {$_ -ne $null})
{
$directory = $objectname.split("\") | select -SkipLast 1
$directory = $directory -join '\'
if($directory | where-object {$_ -ne $directoryonly})
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
$accessmask = $security | select-string -pattern 'AccessMask'
$accessmask = $accessmask.line.Split("=").split(">")[2]
$ext = $file.split(".")[-1]
if ($file -eq $ext)
{
$next = $null
#if($accessmask -eq "0x1")
#{
#$ip + ":::;" + $MAC + ":::;" +"ReadData (or ListDirectory)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $next + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
#}
if($accessmask -eq "0x2")
{
$ip + ":::;" + $MAC + ":::;" + "WriteData (or AddFile)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $next + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}
if($accessmask -eq "0x4")
{
$ip + ":::;" + $MAC + ":::;" + "AppendData (or AddSubdirectory or CreatePipeInstance)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $next + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}
if($accessmask -eq "0x40")
{
$ip + ":::;" + $MAC + ":::;" + "DeleteChild" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $next + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}
#if($accessmask -eq "0x80")
#{
#$ip + ":::;" + $MAC + ":::;" + "ReadAttributes" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $next + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
#}
if($accessmask -eq "0x100")
{
$ip + ":::;" + $MAC + ":::;" + "WriteAttributes" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $next + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}
if($accessmask -eq "0x10000")
{
$ip + ":::;" + $MAC + ":::;" + "DELETE" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $next + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}
#if($accessmask -eq "0x20000")
#{
#$ip + ":::;" + $MAC + ":::;" + "READ_CONTROL" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $next + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
#}
if($accessmask -eq "0x2")
{
$ip + ":::;" + $MAC + ":::;" + "WriteData (or AddFile)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $next + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}
if($accessmask -eq "0x20")
{
$ip + ":::;" + $MAC + ":::;" + "Execute (or Traverse)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $next + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}
if($accessmask -eq "0x4")
{
$ip + ":::;" + $MAC + ":::;" + "AppendData (or AddSubdirectory)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $next + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}
if($accessmask -eq "0x100000")
{
$ip + ":::;" + $MAC + ":::;" + "Synchronize" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $next + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}
#if($accessmask -eq "0x200000")
#{
#$ip + ":::;" + $MAC + ":::;" + "ReadControl" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $next + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
#}
if($accessmask -eq "0x400000")
{
$ip + ":::;" + $MAC + ":::;" + "WriteDAC" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $next + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}
if($accessmask -eq "0x800000")
{
$ip + ":::;" + $MAC + ":::;" + "WriteOwner" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $next + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}
}
elseif ($file -ne $ext)
{
if($accessmask -eq "0x1")
{
$ip + ":::;" + $MAC + ":::;" + "ReadData (or ListDirectory)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}
if($accessmask -eq "0x2")
{
$ip + ":::;" + $MAC + ":::;" + "WriteData (or AddFile)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}
if($accessmask -eq "0x4")
{
$ip + ":::;" + $MAC + ":::;" + "AppendData (or AddSubdirectory or CreatePipeInstance)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}
if($accessmask -eq "0x40")
{
$ip + ":::;" + $MAC + ":::;" + "DeleteChild" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}
if($accessmask -eq "0x80")
{
$ip + ":::;" + $MAC + ":::;" + "ReadAttributes" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}
if($accessmask -eq "0x100")
{
$ip + ":::;" + $MAC + ":::;" + "WriteAttributes" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}
if($accessmask -eq "0x10000")
{
$ip + ":::;" + $MAC + ":::;" + "DELETE" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}
if($accessmask -eq "0x20000")
{
$ip + ":::;" + $MAC + ":::;" + "READ_CONTROL" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}
if($accessmask -eq "0x2")
{
$ip + ":::;" + $MAC + ":::;" + "WriteData (or AddFile)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}
if($accessmask -eq "0x20")
{
$ip + ":::;" + $MAC + ":::;" + "FileExecute (or FileTraverse)" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}
if($accessmask -eq "0x4")
{
$ip + ":::;" + $MAC + ":::;" + "Synchronize" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}

if($accessmask -eq "0x100000")
{
$ip + ":::;" + $MAC + ":::;" + "Synchronize" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}
if($accessmask -eq "0x200000")
{
$ip + ":::;" + $MAC + ":::;" + "ReadControl" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}
if($accessmask -eq "0x400000")
{
$ip + ":::;" + $MAC + ":::;" + "WriteDAC" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}
if($accessmask -eq "0x800000")
{
$ip + ":::;" + $MAC + ":::;" + "WriteOwner" + ":::;" + $eventid + ":::;" + $computer + ":::;" + $username + ":::;" + $date + ":::;" + $time + ":::;" + $sid + ":::;" + $logonid + ":::;" + $domainname + ":::;" + $objectserver + ":::;" + $root + ":::;" + $directory + ":::;" + $file + ":::;" + $ext + ":::;" + $processname | out-file C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_oa_filtered.txt -Append -encoding utf8
}

}
}
}
}
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
$sw.stop()
$sw.Elapsed.tostring('dd\.hh\"mm\:ss\.fff')
