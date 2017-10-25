$ErrorActionPreference = 'silentlycontinue'
$IP = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.netadapter.status -ne "Disconnected"}).ipv4address.ipaddress
$MAC = (Get-NetAdapter | where-object -FilterScript {$_.HardwareInterface -eq "True" -and $_.Status -ne "Disconnected"}).MacAddress
$aroot = (get-psdrive | where-object { [char[]]"CELSTW" -notcontains $_.Name -AND $_.Provider.Name -eq "FileSystem"} | select root).root
[Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem')
foreach ($root in $aroot)
{
foreach($source in (Get-ChildItem $root -file -recurse -filter '*.zip'))
{
$rootd = ($source.directoryname.Split(":"))[0]
$cdatetime = ($file | select CreationTime).CreationTime
$cdatetime = get-date $cdatetime -format yyyy-MM-dd@HH:mm:ss
$cdate = $cdatetime.split("@")[0]
$ctime = $cdatetime.split("@")[1]
$adatetime = ($file | select LastAccessTime).LastAccessTime
$adatetime = get-date $adatetime -format yyyy-MM-dd@HH:mm:ss
$adate = $cdatetime.split("@")[0]
$atime = $cdatetime.split("@")[1]
$mdatetime = ($file | select LastWriteTime).LastWriteTime
$mdatetime = get-date $mdatetime -format yyyy-MM-dd@HH:mm:ss
$mdate = $mdatetime.split("@")[0]
$mtime = $mdatetime.split("@")[1]
[IO.Compression.ZipFile]::OpenRead($source.FullName).Entries | %{$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" +  $cdate + ":::;" + $ctime + “ :“ + $adate + ":::;" + $atime + “ :“ + $mdate + “ :“ + $mtime + “ :“ + "{0:N2}" -f ($source.Length/1kb) + ":::;" + $rootd + ":::;" + $source.DirectoryName + ":::;" + $source.Name + ":::;" + $source.BaseName + ":::;" + $source.Extension + ":::;" + $source.Attributes+ ":::;" + "$($_.FullName):::;$($_.fullname.split(".")[-1]):::;$($_.Length/1kb)" } | Out-File  C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_zip_noC.txt -Append 
}
}