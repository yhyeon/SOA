$sw = [System.Diagnostics.Stopwatch]::startnew()
if(!(test-path 'C:\ProgramData\soalog'))
{new-item -Path "C:\ProgramData\soalog" -ItemType Directory -Force }
$ErrorActionPreference = 'silentlycontinue'
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



[Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem')
$rootdrive = (get-psdrive | where-object { $_.Provider.Name -eq "FileSystem" } | select root).root

get-date -Format yyyy-MM-dd-HH-mm-ss | out-file C:\ProgramData\soalog\fstart.txt -Encoding utf8
get-date -Format yyyy-MM-dd-HH-mm-ss | out-file C:\ProgramData\soalog\zstart.txt -Encoding utf8


if (!(Test-Path -Path 'C:\ProgramData\soalog\ftime.txt'))
{

foreach ($root in $rootdrive)
{
$nhidden = Get-ChildItem -Path $root -file -recurse
$hidden = Get-ChildItem -Path $root -file -recurse -hidden

foreach ($file in $nhidden)
{
$rootd = ($file.directoryname.Split(":"))[0]
$cdatetime = ($file | select CreationTime).CreationTime
$cdatetime = get-date $cdatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$cdate = $cdatetime.split("@")[0]
#$ctime = $cdatetime.split("@")[1]
$adatetime = ($file | select LastAccessTime).LastAccessTime
$adatetime = get-date $adatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$adate = $cdatetime.split("@")[0]
#$atime = $cdatetime.split("@")[1]
$mdatetime = ($file | select LastWriteTime).LastWriteTime
$mdatetime = get-date $mdatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$mdate = $mdatetime.split("@")[0]
#$mtime = $mdatetime.split("@")[1]

$file = $sn + ":::;" + $env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" +  $cdatetime + ":::;" + $adatetime + ":::;" + $mdatetime + ":::;" + "{0:F2}" -f ($file.length/1kb) + ":::;" + $rootd + ":::;" + $file.directoryname.replace("\","\/") + ":::;" + $file.name + ":::;" + $file.basename + ":::;" + $file.extension + ":::;" + $file.attributes +":::;"
$file | Out-File C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmm)_files.txt -Append -Encoding utf8
$file.Dispose()

}
foreach ($file in $hidden)
{
$rootd = ($file.directoryname.Split(":"))[0]
$cdatetime = ($file | select CreationTime).CreationTime
$cdatetime = get-date $cdatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$cdate = $cdatetime.split("@")[0]
#$ctime = $cdatetime.split("@")[1]
$adatetime = ($file | select LastAccessTime).LastAccessTime
$adatetime = get-date $adatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$adate = $cdatetime.split("@")[0]
#$atime = $cdatetime.split("@")[1]
$mdatetime = ($file | select LastWriteTime).LastWriteTime
$mdatetime = get-date $mdatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$mdate = $mdatetime.split("@")[0]
#$mtime = $mdatetime.split("@")[1]

$file = $sn + ":::;" + $env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" +  $cdatetime + ":::;" + $adatetime + ":::;" + $mdatetime + ":::;" + "{0:F2}" -f ($file.length/1kb) + ":::;" + $rootd + ":::;" + $file.directoryname.replace("\","\/") + ":::;" + $file.name + ":::;" + $file.basename + ":::;" + $file.extension + ":::;" + $file.attributes +":::;"
$file | Out-File C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmm)_files.txt -Append -Encoding utf8

$mdatetime.Dispose()
$adatetime.Dispose()
$cdatetime.Dispose()
$rootd.Dispose()
$file.Dispose()
}
$hidden.Dispose()
$nhidden.Dispose()
$root.Dispose()
}
}

else
{
$start = Get-Content C:\ProgramData\soalog\ftime.txt
$start = $start.Replace("-",",").Split(",")
$sy = $start[0]
$sm = $start[1]
$sd = $start[2]
$sh = $start[3]
$smi = $start[4]
$ss = $start[5]
$start = New-Object datetime($sy,$sm,$sd,$sh,$smi,$ss)

foreach ($root in $rootdrive)
{
$nhidden = Get-ChildItem -Path $root -file -recurse | ? {$_.LastWriteTime -gt $start}
$hidden = Get-ChildItem -Path $root -file -recurse -hidden | ? {$_.LastWriteTime -gt $start}


foreach ($file in $nhidden)
{
$rootd = ($file.directoryname.Split(":"))[0]
$cdatetime = ($file | select CreationTime).CreationTime
$cdatetime = get-date $cdatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$cdate = $cdatetime.split("@")[0]
#$ctime = $cdatetime.split("@")[1]
$adatetime = ($file | select LastAccessTime).LastAccessTime
$adatetime = get-date $adatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$adate = $cdatetime.split("@")[0]
#$atime = $cdatetime.split("@")[1]
$mdatetime = ($file | select LastWriteTime).LastWriteTime
$mdatetime = get-date $mdatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$mdate = $mdatetime.split("@")[0]
#$mtime = $mdatetime.split("@")[1]

$file = $sn + ":::;" + $env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" +  $cdatetime + ":::;" + $adatetime + ":::;" + $mdatetime + ":::;" + "{0:F2}" -f ($file.length/1kb) + ":::;" + $rootd + ":::;" + $file.directoryname.replace("\","\/") + ":::;" + $file.name + ":::;" + $file.basename + ":::;" + $file.extension + ":::;" + $file.attributes +":::;"
$file | Out-File C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmm)_files.txt -Append -Encoding utf8
$file.Dispose()

$mdatetime.Dispose()
$adatetime.Dispose()
$cdatetime.Dispose()
$rootd.Dispose()
$file.Dispose()
}
foreach ($file in $hidden)
{
$rootd = ($file.directoryname.Split(":"))[0]
$cdatetime = ($file | select CreationTime).CreationTime
$cdatetime = get-date $cdatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$cdate = $cdatetime.split("@")[0]
#$ctime = $cdatetime.split("@")[1]
$adatetime = ($file | select LastAccessTime).LastAccessTime
$adatetime = get-date $adatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$adate = $cdatetime.split("@")[0]
#$atime = $cdatetime.split("@")[1]
$mdatetime = ($file | select LastWriteTime).LastWriteTime
$mdatetime = get-date $mdatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$mdate = $mdatetime.split("@")[0]
#$mtime = $mdatetime.split("@")[1]

$file = $sn + ":::;" + $env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" +  $cdatetime + ":::;" + $adatetime + ":::;" + $mdatetime + ":::;" + "{0:F2}" -f ($file.length/1kb) + ":::;" + $rootd + ":::;" + $file.directoryname.replace("\","\/") + ":::;" + $file.name + ":::;" + $file.basename + ":::;" + $file.extension + ":::;" + $file.attributes +":::;"
$file | Out-File C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmm)_files.txt -Append -Encoding utf8
$file.Dispose()


$mdatetime.Dispose()
$adatetime.Dispose()
$cdatetime.Dispose()
$rootd.Dispose()
$file.Dispose()
}
$root.Dispose()
$hidden.Dispose()
$nhidden.Dispose()
}
$start.Dispose()
$sy.Dispose()
$sm.Dispose()
$sd.Dispose()
$sh.Dispose()
$smi.Dispose()
$ss.Dispose()
}


if (!(Test-Path -Path 'C:\ProgramData\soalog\ztime.txt'))
{
foreach ($root in $rootdrive)
{
$nhidden = Get-ChildItem -Path $root -file -recurse | ? {$_.name -like "*.zip"}
$hidden = Get-ChildItem -Path $root -file -recurse -hidden | ? {$_.name -like "*.zip"}


foreach ($file in $nhidden)
{
$rootd = ($file.directoryname.Split(":"))[0]
$cdatetime = ($file | select CreationTime).CreationTime
$cdatetime = get-date $cdatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$cdate = $cdatetime.split("@")[0]
#$ctime = $cdatetime.split("@")[1]
$adatetime = ($file | select LastAccessTime).LastAccessTime
$adatetime = get-date $adatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$adate = $cdatetime.split("@")[0]
#$atime = $cdatetime.split("@")[1]
$mdatetime = ($file | select LastWriteTime).LastWriteTime
$mdatetime = get-date $mdatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$mdate = $mdatetime.split("@")[0]
#$mtime = $mdatetime.split("@")[1]

$zip = [IO.Compression.ZipFile]::OpenRead($file.FullName).Entries | %{$sn + ":::;" + $env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" +  $cdatetime + ":::;" + $adatetime + ":::;" + $mdatetime + ":::;" + "{0:F2}" -f ($file.Length/1kb) + ":::;" + $rootd + ":::;" + $file.directoryname.replace("\","\/") + ":::;" + $file.Name + ":::;" + $file.BaseName + ":::;" + $file.Extension + ":::;" + $file.Attributes+ ":::;" + "$($_.FullName):::;$($_.fullname.split(".")[-1]):::;$("{0:F2}" -f ($_.Length/1kb)):::;" }
$zip | Out-File C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmm)_zip.txt -Append -Encoding utf8
$zip.Dispose()

}

foreach ($file in $hidden)
{
$rootd = ($file.directoryname.Split(":"))[0]
$cdatetime = ($file | select CreationTime).CreationTime
$cdatetime = get-date $cdatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$cdate = $cdatetime.split("@")[0]
#$ctime = $cdatetime.split("@")[1]
$adatetime = ($file | select LastAccessTime).LastAccessTime
$adatetime = get-date $adatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$adate = $cdatetime.split("@")[0]
#$atime = $cdatetime.split("@")[1]
$mdatetime = ($file | select LastWriteTime).LastWriteTime
$mdatetime = get-date $mdatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$mdate = $mdatetime.split("@")[0]
#$mtime = $mdatetime.split("@")[1]

$zip = [IO.Compression.ZipFile]::OpenRead($file.FullName).Entries | %{$sn + ":::;" + $env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" +  $cdatetime + ":::;" + $adatetime + ":::;" + $mdatetime + ":::;" + "{0:F2}" -f ($file.Length/1kb) + ":::;" + $rootd + ":::;" + $file.directoryname.replace("\","\/") + ":::;" + $file.Name + ":::;" + $file.BaseName + ":::;" + $file.Extension + ":::;" + $file.Attributes+ ":::;" + "$($_.FullName):::;$($_.fullname.split(".")[-1]):::;$("{0:F2}" -f ($_.Length/1kb)):::;" }
$zip | Out-File C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmm)_zip.txt -Append -Encoding utf8
$zip.Dispose()
}
}
}

else
{
$start = Get-Content C:\ProgramData\soalog\ztime.txt
$start = $start.Replace("-",",").Split(",")
$sy = $start[0]
$sm = $start[1]
$sd = $start[2]
$sh = $start[3]
$smi = $start[4]
$ss = $start[5]
$start = New-Object datetime($sy,$sm,$sd,$sh,$smi,$ss)

foreach ($root in $rootdrive)
{
$nhidden = Get-ChildItem -Path $root -file -recurse | ? {($_.name -like "*.zip") -and ($_.LastWriteTime -gt $start)}
$hidden = Get-ChildItem -Path $root -file -recurse -hidden | ? {($_.name -like "*.zip") -and ($_.LastWriteTime -gt $start)}

foreach ($file in $nhidden)
{
$rootd = ($file.directoryname.Split(":"))[0]
$cdatetime = ($file | select CreationTime).CreationTime
$cdatetime = get-date $cdatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$cdate = $cdatetime.split("@")[0]
#$ctime = $cdatetime.split("@")[1]
$adatetime = ($file | select LastAccessTime).LastAccessTime
$adatetime = get-date $adatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$adate = $cdatetime.split("@")[0]
#$atime = $cdatetime.split("@")[1]
$mdatetime = ($file | select LastWriteTime).LastWriteTime
$mdatetime = get-date $mdatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$mdate = $mdatetime.split("@")[0]
#$mtime = $mdatetime.split("@")[1]

$zip = [IO.Compression.ZipFile]::OpenRead($file.FullName).Entries | %{$sn + ":::;" + $env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" +  $cdatetime + ":::;" + $adatetime + ":::;" + $mdatetime + ":::;" + "{0:F2}" -f ($file.Length/1kb) + ":::;" + $rootd + ":::;" + $file.directoryname.replace("\","\/") + ":::;" + $file.Name + ":::;" + $file.BaseName + ":::;" + $file.Extension + ":::;" + $file.Attributes+ ":::;" + "$($_.FullName):::;$($_.fullname.split(".")[-1]):::;$("{0:F2}" -f ($_.Length/1kb)):::;" }
$zip | Out-File C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmm)_zip.txt -Append -Encoding utf8
$zip.Dispose()

$mdatetime.Dispose()
$adatetime.Dispose()
$cdatetime.Dispose()
$rootd.Dispose()
$file.Dispose()
}
foreach ($file in $hidden)
{
$rootd = ($file.directoryname.Split(":"))[0]
$cdatetime = ($file | select CreationTime).CreationTime
$cdatetime = get-date $cdatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$cdate = $cdatetime.split("@")[0]
#$ctime = $cdatetime.split("@")[1]
$adatetime = ($file | select LastAccessTime).LastAccessTime
$adatetime = get-date $adatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$adate = $cdatetime.split("@")[0]
#$atime = $cdatetime.split("@")[1]
$mdatetime = ($file | select LastWriteTime).LastWriteTime
$mdatetime = get-date $mdatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$mdate = $mdatetime.split("@")[0]
#$mtime = $mdatetime.split("@")[1]

$zip = [IO.Compression.ZipFile]::OpenRead($file.FullName).Entries | %{$sn + ":::;" + $env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" +  $cdatetime + ":::;" + $adatetime + ":::;" + $mdatetime + ":::;" + "{0:F2}" -f ($file.Length/1kb) + ":::;" + $rootd + ":::;" + $file.directoryname.replace("\","\/") + ":::;" + $file.Name + ":::;" + $file.BaseName + ":::;" + $file.Extension + ":::;" + $file.Attributes+ ":::;" + "$($_.FullName):::;$($_.fullname.split(".")[-1]):::;$("{0:F2}" -f ($_.Length/1kb)):::;" }
$zip | Out-File C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmm)_zip.txt -Append -Encoding utf8
$zip.Dispose()


$mdatetime.Dispose()
$adatetime.Dispose()
$cdatetime.Dispose()
$rootd.Dispose()
$file.Dispose()
}

$hidden.Dispose()
$nhidden.Dispose()
}
$start.Dispose()
$sy.Dispose()
$sm.Dispose()
$sd.Dispose()
$sh.Dispose()
$smi.Dispose()
$ss.Dispose()
}
$path.Dispose()
$sn.Dispose()
$MAC.Dispose()
$IP.Dispose()

$sw.stop()
$sw.Elapsed.tostring('dd\.hh\"mm\:ss\.fff')


$sw = [System.Diagnostics.Stopwatch]::startnew()
$ErrorActionPreference = 'silentlycontinue'
Import-Module bitstransfer
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
#$src = "C:\ProgramData\soalog\" # directory in which files to be sent
$src = "C:\ProgramData\soalog\*_files.txt", "C:\ProgramData\soalog\*_zip.txt"
Get-ChildItem -path $src |
foreach {
$dst = "http://cdisc.co.kr:1024/soa/upload/$($_.name)" # server directory with write permissions
$job = Start-BitsTransfer -source $($_.FullName) -Destination $dst -Credential $cred -TransferType Upload -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting"))
{sleep 10;}
if ($job.JobState -eq "Transferred")
{
Remove-Item $($_.FullName) -Force
$today = get-date -Format yyyy-MM-dd
$fstart = (Get-Content C:\ProgramData\soalog\fstart.txt).Split("-")[0,1,2] -join "-"
if ($fstart -eq $today)
{
Get-Content -Path "C:\ProgramData\soalog\fstart.txt" | out-file C:\ProgramData\soalog\ftime.txt -encoding utf8
}

$zstart = (Get-Content C:\ProgramData\soalog\zstart.txt).Split("-")[0,1,2] -join "-"
if ($zstart -eq $today)
{
Get-Content -Path "C:\ProgramData\soalog\zstart.txt" | out-file C:\ProgramData\soalog\ztime.txt -encoding utf8
}
}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
"TransientError" {Resume-BitsTransfer -BitsJob $job}
"Error" {Resume-BitsTransfer -BitsJob $job}
}
$dst.Dispose()
$job.Dispose()
}
$enc.Dispose()
$user.Dispose()
$cred.Dispose()
$src.Dispose()

#Clear-Variable file, root, compare1, compare2
#[System.GC]::Collect()
$sw.stop()
$sw.Elapsed.tostring('dd\.hh\"mm\:ss\.fff')
