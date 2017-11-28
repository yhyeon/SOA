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
foreach ($root in $rootdrive)
{
foreach ($file in (Get-ChildItem $root -file -recurse))
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

if (!(Test-Path -Path 'C:\ProgramData\soalog\f.txt'))
{
$file = $sn + ":::;" + $env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" +  $cdatetime + ":::;" + $adatetime + ":::;" + $mdatetime + ":::;" + "{0:F2}" -f ($file.length/1kb) + ":::;" + $rootd + ":::;" + $file.directoryname.replace("\","\/") + ":::;" + $file.name + ":::;" + $file.basename + ":::;" + $file.extension + ":::;" + $file.attributes +":::;"
$file | Out-File C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_files.txt -Append -Encoding utf8
$file.Dispose()
}
else
{
$compare1 = Get-Content -Path 'C:\ProgramData\soalog\f.txt'
$cfile = $sn + ":::;" + $env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" +  $cdatetime + ":::;" + $adatetime + ":::;" + $mdatetime + ":::;" + "{0:F2}" -f ($file.length/1kb) + ":::;" + $rootd + ":::;" + $file.directoryname.replace("\","\/") + ":::;" + $file.name + ":::;" + $file.basename + ":::;" + $file.extension + ":::;" + $file.attributes +":::;" | Where-Object {$_ -notin $compare1}
$cfile | Out-File C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_files.txt -Append -Encoding utf8
$cfile.Dispose()
$compare1.Dispose()
}
if ($file -like "*.zip")
{
if (!(Test-Path -Path 'C:\ProgramData\soalog\z.txt'))
{
$zip = [IO.Compression.ZipFile]::OpenRead($file.FullName).Entries | %{$sn + ":::;" + $env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" +  $cdatetime + ":::;" + $adatetime + ":::;" + $mdatetime + ":::;" + "{0:F2}" -f ($file.Length/1kb) + ":::;" + $rootd + ":::;" + $file.directoryname.replace("\","\/") + ":::;" + $file.Name + ":::;" + $file.BaseName + ":::;" + $file.Extension + ":::;" + $file.Attributes+ ":::;" + "$($_.FullName):::;$($_.fullname.split(".")[-1]):::;$("{0:F2}" -f ($_.Length/1kb)):::;" }
$zip | Out-File C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_zip.txt -Append -Encoding utf8
$zip.Dispose()
}
else
{
$compare2 = Get-Content -Path 'C:\ProgramData\soalog\z.txt'
$czip = [IO.Compression.ZipFile]::OpenRead($file.FullName).Entries | %{$sn + ":::;" + $env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" +  $cdatetime + ":::;" + $adatetime + ":::;" + $mdatetime + ":::;" + "{0:F2}" -f ($file.Length/1kb) + ":::;" + $rootd + ":::;" + $file.directoryname.replace("\","\/") + ":::;" + $file.Name + ":::;" + $file.BaseName + ":::;" + $file.Extension + ":::;" + $file.Attributes+ ":::;" + "$($_.FullName):::;$($_.fullname.split(".")[-1]):::;$("{0:F2}" -f ($_.Length/1kb)):::;" } | Where-Object {$_ -notin $compare2}
$czip | Out-File C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_zip.txt -Append -Encoding utf8
$czip.Dispose()
$compare2.Dispose()
}
}
$mdatetime.Dispose()
$adatetime.Dispose()
$cdatetime.Dispose()
$rootd.Dispose()
$file.Dispose()
}
$root.Dispose()
}
$rootdrive.Dispose()
$sn.Dispose()
$MAC.Dispose()
$IP.Dispose()

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
if ($_.Name -match "files.txt")
{
get-content $($_.FullName) | Out-File "C:\ProgramData\soalog\f.txt" -Append -Encoding UTF8
}
if ($_.Name -match "zip.txt")
{
get-content $($_.FullName) | Out-File "C:\ProgramData\soalog\z.txt" -Append -Encoding UTF8
}
Remove-Item $($_.FullName) -Force
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