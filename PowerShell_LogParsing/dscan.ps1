do {
$sw = [System.Diagnostics.Stopwatch]::startnew()
$ErrorActionPreference = 'silentlycontinue'

if(!(test-path 'C:\ProgramData\soalog'))
{new-item -Path "C:\ProgramData\soalog" -ItemType Directory -Force }


$drive = ((Get-PSDrive -PSProvider FileSystem | Where-Object name -ne "C" | select root).root).count

if (((Get-PSDrive -PSProvider FileSystem | Where-Object name -ne "C" | select root).root).count -ne $drive)
{
[Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem')

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


$currentdatetime = Get-Date -Format yyyy-MM-ddTHH:mm:ss+09:00
#$currentdate = [string]$currentdatetime.split("@")[0]
#$currenttime = [string]$currentdatetime.split("@")[1]
foreach ($root in ((get-psdrive -PSProvider FileSystem |Where-Object name -ne "C" | select root).root))
{
$dir = Get-ChildItem $root -file -recurse
$rootn = $root.split(":")[0]
$docc = ($dir -like "*.doc").count
$doc = ($dir -like "*.doc")
foreach ($docf in $doc)
{
$doce = "."+($docf.split(".")[-1])
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $docf + ":::;" + $doce + ":::;" +$docc + ":::;" + $currentdatetime + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_${rootn}_dscanquicks.txt -Append -encoding utf8
}
$hwpc = ($dir -like "*.hwp").count
$hwp = ($dir -like "*.hwp")
foreach ($hwpf in $hwp)
{
$hwpe = "."+($hwpf.split(".")[-1])
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $hwpf + ":::;" + $hwpe + ":::;" +$hwpc + ":::;" + $currentdatetime + ":::;"  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_${rootn}_dscanquicks.txt -Append -encoding utf8
}
$pdfc = ($dir -like "*.pdf").count
$pdf = ($dir -like "*.pdf")
foreach ($pdff in $pdf)
{
$pdfe = "."+($pdff.split(".")[-1])
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $pdff + ":::;" + $pdfe + ":::;" +$pdfc + ":::;" + $currentdatetime + ":::;"  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_${rootn}_dscanquicks.txt -Append -encoding utf8
}
$xlsc = ($dir -like "*.xls").count
$xls = ($dir -like "*.xls")
foreach ($xlsf in $xls)
{
$xlse = "."+($xlsf.split(".")[-1])
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $xlsf + ":::;" + $xlse + ":::;" +$xlsc + ":::;" + $currentdatetime + ":::;"  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_${rootn}_dscanquicks.txt -Append -encoding utf8
}
$csvc = ($dir -like "*.csv").count
$csv = ($dir -like "*.csv")
foreach ($csvf in $csv)
{
$csve = "."+($csvf.split(".")[-1])
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $csvf + ":::;" + $csve + ":::;" +$csvc + ":::;" + $currentdatetime + ":::;"  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_${rootn}_dscanquicks.txt -Append -encoding utf8
}
$pngc = ($dir -like "*.png").count
$png = ($dir -like "*.png")
foreach ($pngf in $png)
{
$pnge = "."+($pngf.split(".")[-1])
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $pngf + ":::;" + $pnge + ":::;" +$pngc + ":::;" + $currentdatetime + ":::;"  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_${rootn}_dscanquicks.txt -Append -encoding utf8
}
$jpc = ($dir -like "*.jp*").count
$jp = ($dir -like "*.jp*")
foreach ($jpf in $jp)
{
$jpe = "."+($jpf.split(".")[-1])
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $jpf + ":::;" + $jpe + ":::;" +$jpc + ":::;" + $currentdatetime + ":::;"  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_${rootn}_dscanquicks.txt -Append -encoding utf8
}
$zc = ($dir -like "*.*zip").count
$z = ($dir -like "*.*zip")
foreach ($zf in $z)
{
$ze = "."+($zf.split(".")[-1])
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $zf + ":::;" + $ze + ":::;" +$zc + ":::;" + $currentdatetime + ":::;"  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_${rootn}_dscanquicks.txt -Append -encoding utf8
}
$7zc = ($dir -like "*.7z").count
$7z = ($dir -like "*.7z")
foreach ($7zf in $7z)
{
$7ze = "."+($7zf.split(".")[-1])
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $7zf + ":::;" + $7ze + ":::;" +$7zc + ":::;" + $currentdatetime + ":::;"  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_${rootn}_dscanquicks.txt -Append -encoding utf8
}
$noec = ($dir | Where-Object {$_.extension -eq ""}).count
$noe = ($dir | Where-Object {$_.extension -eq ""} | select Name).name
foreach ($noef in $noe)
{
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $noef + ":::;" + ":::;" +$noec + ":::;" + $currentdatetime + ":::;"  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_${rootn}_dscanquicks.txt -Append -encoding utf8
}
$splitc = ($dir -like "*.0??").count
$split = ($dir -like "*.0??")
foreach ($splitf in $split)
{
$splite = "."+($splitf.split(".")[-1])
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $splitf + ":::;" + $splite + ":::;" +$splitc + ":::;" + $currentdatetime + ":::;"  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_${rootn}_dscanquicks.txt -Append -encoding utf8
}
$splitc2 = ($dir -like "*._").count
$split2 = ($dir -like "*._")
foreach ($split2f in $split2)
{
$split2e = "."+($split2f.split(".")[-1])
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $split2f + ":::;" + $split2e + ":::;" +$splitc2 + ":::;" + $currentdatetime + ":::;"  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_${rootn}_dscanquicks.txt -Append -encoding utf8
}
$txtc = ($dir -like "*tx*").count
$txt = ($dir -like "*.tx*")
foreach ($txtf in $txt)
{
$txte = "."+($txtf.split(".")[-1])
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $txtf + ":::;" + $txte + ":::;" +$txtc + ":::;" + $currentdatetime + ":::;"  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_${rootn}_dscanquicks.txt -Append -encoding utf8
}
$sw.Elapsed.tostring('dd\.hh\"mm\:ss\.fff')
foreach ($file in $dir)
{
$rootd = ($file.directoryname.Split(":"))[0]
$cdatetime = ($file | select CreationTime).CreationTime
$cdatetime = get-date $cdatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$cdate = [string]$cdatetime.split("@")[0]
#$ctime = [string]$cdatetime.split("@")[1]
$adatetime = ($file | select LastAccessTime).LastAccessTime
$adatetime = get-date $adatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$adate = [string]$cdatetime.split("@")[0]
#$atime = [string]$cdatetime.split("@")[1]
$mdatetime = ($file | select LastWriteTime).LastWriteTime
$mdatetime = get-date $mdatetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$mdate = [string]$mdatetime.split("@")[0]
#$mtime = [string]$mdatetime.split("@")[1]
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $cdatetime + ":::;" + $adatetime + ":::;" + $mdatetime + ":::;" + "{0:N2}" -f ($file.length/1kb) + ":::;" + $rootd + ":::;" + $file.directoryname + ":::;" + $file.name + ":::;" + $file.basename + ":::;" + $file.extension + ":::;" + $file.attributes + ":::;"  | Out-File C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_${rootn}_dscanfiles.txt -Append -Encoding utf8
if ($file -like "*.zip")
{
[IO.Compression.ZipFile]::OpenRead($file.FullName).Entries | %{$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" +  $cdatetime + ":::;" + $adatetime + ":::;" + $mdatetime + ":::;" + "{0:N2}" -f ($file.Length/1kb) + ":::;" + $rootd + ":::;" + $file.DirectoryName + ":::;" + $file.Name + ":::;" + $file.BaseName + ":::;" + $file.Extension + ":::;" + $file.Attributes+ ":::;" + "$($_.FullName):::;$($_.fullname.split(".")[-1]):::;$($_.Length/1kb):::;" } | Out-File  C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_${rootn}_dscanzip.txt -Append -Encoding utf8
}
}
}

$events = get-winevent -FilterHashtable @{logname = 'Microsoft-Windows-Partition/Diagnostic'} -MaxEvents 2 | foreach {$_.toxml()}
foreach ($partition in $events)
{
$partition = $partition.split("<")
$eventrecordid = $partition | select-string -pattern 'EventRecordID>'
$eventrecordid = $eventrecordid.line.trim("/*")
$eventid = $partition | select-string -pattern 'EventID'
$eventid = $eventid.line.split(">")[1]
$datetime = $partition | select-string -pattern 'TimeCreated'
$datetime = [datetime]($datetime.line.split("=").split("/>").split("'")[2])
$datetime = get-date $datetime -format yyyy-MM-ddTHH:mm:ss+09:00
#$date = [string]$datetime.Split("@")[0]
#$time = [string]$datetime.Split("@")[1]
$computer = $partition | select-string -pattern 'Computer'
$computer = $computer.line.split(">")[1]
$sid = $partition | select-string -pattern 'Security UserID'
$sid = $sid.line.split("=").split("/>").split("'")[2]
$disknumber = $partition | select-string -pattern 'DiskNumber'
$disknumber = $disknumber.line.Split("=").Split(">").Split("'")[4]
$characteristics = $partition | select-string -Pattern 'Characteristics'
$characteristics = $characteristics.Line.Split("=").Split(">").Split("'")[4]
$busType = $partition | Select-String -Pattern 'BusType'
$bustype = $busType.Line.Split("=").Split(">").Split("'")[4]
$manufacturer = $partition | select-string -pattern 'Manufacturer'
$manufacturer = $manufacturer.line.split("=").split(">").Split("'")[4]
$model = $partition | select-string -Pattern 'Model'
$model = $model.line.Split("=").Split(">").Split("'")[4]
$revision = $partition | select-string -pattern 'Revision'
$revision = $revision.Line.Split("=").Split(">").Split("'")[4]
$serialnumber = $partition | select-string -Pattern 'SerialNumber'
$serialnumber = $serialnumber.line.split("=").Split(">").Split("'")[4]
$parentid = $partition | select-string -Pattern 'ParentId'
$parentid = $parentid.line.split("=").split(">").split("'")[4]
$parentid = $parentid.replace("&amp;","&")
$diskid = $partition | select-string -Pattern 'DiskId'
$diskid = $diskid.line.Split("=").Split(">").Split("'").split("{").split("}")[5]
$registryid = $partition | select-string -Pattern 'RegistryId'
$registryid = $registryid.line.Split("=").Split(">").Split("'").split("{").split("}")[5]

$compare = Get-Content -Path 'C:\ProgramData\soalog\p.txt'
if (! (Test-Path -Path 'C:\ProgramData\soalog\p.txt'))
{
$sn + ":::;" + $ip + ":::;" + $mac + ":::;" + $computer + ":::;" + $sid + ":::;" + $datetime + ":::;" + $eventid + ":::;" + $disknumber + ":::;" + $diskid + ":::;" + $characteristics + ":::;" + $busType + ":::;" + $manufacturer + ":::;" + $model + ":::;" + $revision + ":::;" + $serialnumber + ":::;" + $parentid + ":::;" + $registryid + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_${rootn}_dscanpart.txt -Append -Encoding utf8
}
else
{
$sn + ":::;" + $ip + ":::;" + $mac + ":::;" + $computer + ":::;" + $sid + ":::;" + $datetime + ":::;" + $eventid + ":::;" + $disknumber + ":::;" + $diskid + ":::;" + $characteristics + ":::;" + $busType + ":::;" + $manufacturer + ":::;" + $model + ":::;" + $revision + ":::;" + $serialnumber + ":::;" + $parentid + ":::;" + $registryid + ":::;" | Where-Object {$_ -notin $compare} | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHH)_${rootn}_dscanpart.txt -Append -Encoding utf8
}
$sw.stop()
$sw.Elapsed.tostring('dd\.hh\"mm\:ss\.fff')
$drive = ((Get-PSDrive -PSProvider FileSystem | Where-Object name -ne "C" | select root).root).count
if($?)
{
Start-Job -ArgumentList invoke-item C:\Windows\soa\busd.ps1
}
}
sleep 1
((Get-PSDrive -PSProvider FileSystem | Where-Object name -ne "C" | select root).root).count
}
}
While ($true)