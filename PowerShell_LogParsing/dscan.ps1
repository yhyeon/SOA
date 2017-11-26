if(!(test-path 'C:\ProgramData\soalog'))
{new-item -Path "C:\ProgramData\soalog" -ItemType Directory -Force }
$sw = [System.Diagnostics.Stopwatch]::startnew()
$ErrorActionPreference = 'silentlycontinue'

$drive = ((Get-PSDrive -PSProvider FileSystem | Where-Object name -ne "C" | select root).root).count

do {

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

$rootdrive = (get-psdrive -PSProvider FileSystem |Where-Object name -ne "C" | select root).root
foreach ($root in $rootdrive)
{
$dir = Get-ChildItem $root -file -recurse
$rootn = $root.split(":")[0]
$docc = ($dir -match "*.doc").count
$doc = ($dir -match "*.doc")
foreach ($docf in $doc)
{
$doce = "."+($docf.split(".")[-1])
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $docf + ":::;" + $doce + ":::;" +$docc + ":::;" + $currentdatetime + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_${rootn}_dscanquicks.txt -Append -encoding utf8
$docf.Dispose()
$doce.Dispose()
}
$doc.Dispose()
$docc.Dispose()


$hwpc = ($dir -match "*.hwp").count
$hwp = ($dir -match "*.hwp")
foreach ($hwpf in $hwp)
{
$hwpe = "."+($hwpf.split(".")[-1])
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $hwpf + ":::;" + $hwpe + ":::;" +$hwpc + ":::;" + $currentdatetime + ":::;"  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_${rootn}_dscanquicks.txt -Append -encoding utf8
$hwpf.Dispose()
$hwpe.Dispose()
}
$hwpc.Dispose()
$hwp.Dispose()

$pdfc = ($dir -match "*.pdf").count
$pdf = ($dir -match "*.pdf")
foreach ($pdff in $pdf)
{
$pdfe = "."+($pdff.split(".")[-1])
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $pdff + ":::;" + $pdfe + ":::;" +$pdfc + ":::;" + $currentdatetime + ":::;"  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_${rootn}_dscanquicks.txt -Append -encoding utf8
$pdff.Dispose()
$pdfe.Dispose()
}
$pdf.Dispose()
$pdfc.Dispose()

$xlsc = ($dir -match "*.xls").count
$xls = ($dir -match "*.xls")
foreach ($xlsf in $xls)
{
$xlse = "."+($xlsf.split(".")[-1])
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $xlsf + ":::;" + $xlse + ":::;" +$xlsc + ":::;" + $currentdatetime + ":::;"  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_${rootn}_dscanquicks.txt -Append -encoding utf8
$xlse.Dispose()
$xlsf.Dispose()
}
$xls.Dispose()
$xlsc.Dispose()

$csvc = ($dir -like "*.csv").count
$csv = ($dir -like "*.csv")
foreach ($csvf in $csv)
{
$csve = "."+($csvf.split(".")[-1])
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $csvf + ":::;" + $csve + ":::;" +$csvc + ":::;" + $currentdatetime + ":::;"  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_${rootn}_dscanquicks.txt -Append -encoding utf8
$csve.Dispose()
$csvf.Dispose()
}
$csv.Dispose()
$csvc.Dispose()

$pngc = ($dir -match "*.png").count
$png = ($dir -match "*.png")
foreach ($pngf in $png)
{
$pnge = "."+($pngf.split(".")[-1])
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $pngf + ":::;" + $pnge + ":::;" +$pngc + ":::;" + $currentdatetime + ":::;"  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_${rootn}_dscanquicks.txt -Append -encoding utf8
$pnge.Dispose()
$pngf.Dispose()
}
$pngc.Dispose()
$png.Dispose()

$jpc = ($dir -match "*.jp*").count
$jp = ($dir -match "*.jp*")
foreach ($jpf in $jp)
{
$jpe = "."+($jpf.split(".")[-1])
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $jpf + ":::;" + $jpe + ":::;" +$jpc + ":::;" + $currentdatetime + ":::;"  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_${rootn}_dscanquicks.txt -Append -encoding utf8
$jpe.Dispose()
$jpf.Dispose()
}
$jp.Dispose()
$jpc.Dispose()

$zc = ($dir -match "*.*zip").count
$z = ($dir -match "*.*zip")
foreach ($zf in $z)
{
$ze = "."+($zf.split(".")[-1])
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $zf + ":::;" + $ze + ":::;" +$zc + ":::;" + $currentdatetime + ":::;"  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_${rootn}_dscanquicks.txt -Append -encoding utf8
$ze.Dispose()
$zf.Dispose()
}
$z.Dispose()
$zc.Dispose()

$7zc = ($dir -match "*.7z").count
$7z = ($dir -match "*.7z")
foreach ($7zf in $7z)
{
$7ze = "."+($7zf.split(".")[-1])
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $7zf + ":::;" + $7ze + ":::;" +$7zc + ":::;" + $currentdatetime + ":::;"  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_${rootn}_dscanquicks.txt -Append -encoding utf8
$7ze.Dispose()
$7zf.Dispose()
}
$7z.Dispose()
$7zc.Dispose()

$noec = ($dir | Where-Object {$_.extension -eq ""}).count
$noe = ($dir | Where-Object {$_.extension -eq ""} | select Name).name
foreach ($noef in $noe)
{
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $noef + ":::;" + ":::;" +$noec + ":::;" + $currentdatetime + ":::;"  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_${rootn}_dscanquicks.txt -Append -encoding utf8
$noef.Dispose()
}
$noe.Dispose()
$noec.Dispose()

$splitc = ($dir -like "*.0??").count
$split = ($dir -like "*.0??")
foreach ($splitf in $split)
{
$splite = "."+($splitf.split(".")[-1])
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $splitf + ":::;" + $splite + ":::;" +$splitc + ":::;" + $currentdatetime + ":::;"  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_${rootn}_dscanquicks.txt -Append -encoding utf8
$splite.Dispose()
$splitf.Dispose()
}
$split.Dispose()
$splitc.Dispose()

$splitc2 = ($dir -like "*._").count
$split2 = ($dir -like "*._")
foreach ($split2f in $split2)
{
$split2e = "."+($split2f.split(".")[-1])
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $split2f + ":::;" + $split2e + ":::;" +$splitc2 + ":::;" + $currentdatetime + ":::;"  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_${rootn}_dscanquicks.txt -Append -encoding utf8
$split2e.Dispose()
$split2f.Dispose()
}
$split2.Dispose()
$splitc2.Dispose()

$txtc = ($dir -like "*.tx*").count
$txt = ($dir -like "*.tx*")
foreach ($txtf in $txt)
{
$txte = "."+($txtf.split(".")[-1])
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $txtf + ":::;" + $txte + ":::;" +$txtc + ":::;" + $currentdatetime + ":::;"  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_${rootn}_dscanquicks.txt -Append -encoding utf8
$txte.Dispose()
$txtf.Dispose()
}
$txtc.Dispose()
$txt.Dispose()

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
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" + $cdatetime + ":::;" + $adatetime + ":::;" + $mdatetime + ":::;" + "{0:N2}" -f ($file.length/1kb) + ":::;" + $rootd + ":::;" + $file.directoryname.replace("\","\/") + ":::;" + $file.name + ":::;" + $file.basename + ":::;" + $file.extension + ":::;" + $file.attributes + ":::;"  | Out-File C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_${rootn}_dscanfiles.txt -Append -Encoding utf8
if ($file -like "*.zip")
{
[IO.Compression.ZipFile]::OpenRead($file.FullName).Entries | %{$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" +  $cdatetime + ":::;" + $adatetime + ":::;" + $mdatetime + ":::;" + "{0:N2}" -f ($file.Length/1kb) + ":::;" + $rootd + ":::;" + $file.DirectoryName.replace("\","\/") + ":::;" + $file.Name + ":::;" + $file.BaseName + ":::;" + $file.Extension + ":::;" + $file.Attributes+ ":::;" + "$($_.FullName):::;$($_.fullname.split(".")[-1]):::;$($_.Length/1kb):::;" } | Out-File  C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_${rootn}_dscanzip.txt -Append -Encoding utf8
}
$rootd.Dispose()
$cdatetime.Dispose()
$adatetime.Dispose()
$mdatetime.Dispose()
$file.Dispose()
}
$dir.Dispose()
}
$root.Dispose()
$rootdrive.Dispose()
$currentdatetime.Dispose()

$partitionlog = get-winevent -FilterHashtable @{logname = 'Microsoft-Windows-Partition/Diagnostic'} -MaxEvents 2 | foreach {$_.toxml()}
#foreach ($partition in (get-winevent -FilterHashtable @{logname = 'Microsoft-Windows-Partition/Diagnostic'} -MaxEvents 2 | foreach {$_.toxml()}))
foreach ($partition in $partitionlog)
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

$sn + ":::;" + $ip + ":::;" + $mac + ":::;" + $computer + ":::;" + $sid + ":::;" + $datetime + ":::;" + $eventid + ":::;" + $disknumber + ":::;" + $diskid + ":::;" + $characteristics + ":::;" + $busType + ":::;" + $manufacturer + ":::;" + $model + ":::;" + $revision + ":::;" + $serialnumber + ":::;" + $parentid + ":::;" + $registryid + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_${rootn}_dscanpart.txt -Append -Encoding utf8

$eventrecordid.Dispose()
$eventid.Dispose()
$datetime.Dispose()
$computer.Dispose()
$sid.Dispose()
$disknumber.Dispose()
$characteristics.Dispose()
$busType.Dispose()
$manufacturer.Dispose()
$model.Dispose()
$revision.Dispose()
$serialnumber.Dispose()
$parentid.Dispose()
$diskid.Dispose()
$registryid.Dispose()
$partition.Dispose()
$drive.Dispose()
$sn.Dispose()
$MAC.Dispose()
$IP.Dispose()
$partition.Dispose()
$partitionlog.Dispose()

$sw.stop()
$sw.Elapsed.tostring('dd\.hh\"mm\:ss\.fff')
$drive = ((Get-PSDrive -PSProvider FileSystem | Where-Object name -ne "C" | select root).root).count

Start-Job -ArgumentList invoke-item C:\Windows\soa\busd.ps1

}
sleep 1

#Clear-Variable driver, eventid, partition, compare, file, dir


((Get-PSDrive -PSProvider FileSystem | Where-Object name -ne "C" | select root).root).count
}
}
While ($true)