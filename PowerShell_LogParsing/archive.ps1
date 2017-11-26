[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
$enc = get-content C:\Windows\enp.txt | ConvertTo-SecureString
$user = "root"
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)

$conn = Connect-MySqlServer -Credential $cred 192.168.0.21 -Port 3306 -Database soa_log

$conn.open()

$query = "select * from oafile where file is not null;"
$cmd = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $conn)
$dataadapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($cmd)
$dataset = New-Object system.data.dataset
$recordcount = $dataadapter.fill($dataset, "oafile")
$qresult = $dataset.Tables["oafile"]

$zip_proc = "'*/Bandizip.exe, '*/ALZip.exe, '*7z.exe, '*Winzip.exe, '*WinRAR.exe, '*BreadZip.exe, '*HanZip.exe"

$exreadcontrol = ($qresult | Where-Object {($_.accessmask -eq "READ_CONTROL") -and ($_.PSname -match "'*/Bandizip.exe") -or ($_.PSname -match "'*/ALZip.exe") -or ($_.PSname -match "'*7z.exe") -or ($_.PSname -match "'*Winzip.exe") -or ($_.PSname -match "'*WinRAR.exe") -or ($_.PSname -match "'*BreadZip.exe") -or ($_.PSname -match "'*HanZip.exe")} | select DiskSN, IP, MAC, cname, uname, root, directory, datetime, file, ext)

$exwritedata = ($qresult | Where-Object {($_.accessmask -eq "WriteData (or AddFile)") -and ($_.PSname -match "'*/Bandizip.exe")-or ($_.PSname -match "'*/ALZip.exe") -or ($_.PSname -match "'*7z.exe") -or ($_.PSname -match "'*Winzip.exe") -or ($_.PSname -match "'*WinRAR.exe") -or ($_.PSname -match "'*BreadZip.exe") -or ($_.PSname -match "'*HanZip.exe")} | select DiskSN, IP, MAC, cname, uname, root, directory, datetime, file, ext)

<# -------------------------------------------------------------------------------------------------------------------------------------#>
$exdelete = ($qresult | Where-Object {($_.accessmask -eq "DELETE") -and ($_.PSname -match "'*/Bandizip.exe")-or ($_.PSname -match "'*/ALZip.exe") -or ($_.PSname -match "'*7z.exe") -or ($_.PSname -match "'*Winzip.exe") -or ($_.PSname -match "'*WinRAR.exe") -or ($_.PSname -match "'*BreadZip.exe") -or ($_.PSname -match "'*HanZip.exe")} | select DiskSN, IP, MAC, cname, uname, root, directory, datetime, file, ext)
<# -------------------------------------------------------------------------------------------------------------------------------------#>

$exreadattributes = ($qresult | Where-Object {($_.accessmask -eq "ReadAttributes") -and ($_.PSname -match "'*/Bandizip.exe")-or ($_.PSname -match "'*/ALZip.exe") -or ($_.PSname -match "'*7z.exe") -or ($_.PSname -match "'*Winzip.exe") -or ($_.PSname -match "'*WinRAR.exe") -or ($_.PSname -match "'*BreadZip.exe") -or ($_.PSname -match "'*HanZip.exe")} | select DiskSN, IP, MAC, cname, uname, root, directory, datetime, file, ext)

$exwritedata = ($qresult | Where-Object {($_.accessmask -eq "ReadData (or ListDirectory)") -and ($_.PSname -match "'*/Bandizip.exe")-or ($_.PSname -match "'*/ALZip.exe") -or ($_.PSname -match "'*7z.exe") -or ($_.PSname -match "'*Winzip.exe") -or ($_.PSname -match "'*WinRAR.exe") -or ($_.PSname -match "'*BreadZip.exe") -or ($_.PSname -match "'*HanZip.exe")} | select DiskSN, IP, MAC, cname, uname, root, directory, datetime, file, ext)
<# -------------------------------------------------------------------------------------------------------------------------------------#>

foreach ($ziptime in $exdelete)
{
$zip_hour = $ziptime.datetime.split(":")[0]
$zip_min = $ziptime.datetime.split(":")[1]
$zip_sec = $ziptime.datetime.split(":")[2].split("+")[0]
foreach($result1 in $exreadattributes)
{
$ra_hour = $result1.datetime.split(":")[0]
$ra_min = $result1.datetime.split(":")[1]
$ra_sec = $result1.datetime.split(":")[2].split("+")[0]

foreach ($result in $exwritedata)
{
if($result1.datetime -eq $result.datetime -and $result1.file -eq $result.file)
{
    if(($zip_hour -eq $ra_hour) -and ($zip_min -eq $ra_min) -and (($zip_sec -eq $ra_sec) -or ([int]$zip_sec -eq [int]$ra_sec+1) -or ([int]$zip_sec -eq [int]$ra_sec+2) -or ([int]$zip_sec -eq [int]$ra_sec+3) -or ([int]$zip_sec -eq [int]$ra_sec+4) -or ([int]$zip_sec -eq [int]$ra_sec+5)))
    {
    
    
    $outfile = $result1.DiskSN + ":::;"+ $result1.IP + ":::;"+ $result1.MAC + ":::;"+ $result1.cname + ":::;"+ $result1.uname + ":::;"+ $result1.datetime + ":::;"+ $result1.root + ":::;" + $result1.directory + ":::;"+ $result1.file + ":::;"+ $result1.ext + ":::;" + $ziptime.root + ":::;"+ $ziptime.directory + ":::;"+ $ziptime.file + ":::;"+ $ziptime.ext + ":::;"
   
   if (!(Test-Path("C:\backlog\filter")))
{new-item -Path "C:\backlog\filter" -ItemType Directory -Force}

if (!(Test-Path("C:\backlog\filter\archive.txt")))
{

   $outfile | Out-File "C:\backlog\filter\archive.txt" -Append -Encoding utf8
$query = "load data local infile" + " " + "'" + "C:\backlog\filter\archive.txt".replace("\","\\") + "'" + " " + "into table soa_log.archive fields terminated by ':::;' lines terminated by '\n' (DiskSN,IP,MAC,Cname,Uname,datetime,src_root,src_directory,src_file,src_ext,arc_root,arc_directory,arc_file,arc_ext,curs);"
Invoke-MySqlQuery -Query $query
Invoke-MySqlQuery -query "select * from soa_log.archive order by id desc limit 1;"
}
elseif (Test-Path("C:\backlog\filter\archive.txt"))
{
$compare = Get-Content -Path "C:\backlog\filter\archive.txt"
$outfile | Where-Object {$_ -notin $compare} | Out-File "C:\backlog\filter\archive_tmp.txt" -Append -Encoding utf8
$outfile | Where-Object {$_ -notin $compare} | Out-File "C:\backlog\filter\archive.txt" -Append -Encoding utf8
$query = "load data local infile" + " " + "'" + "C:\backlog\filter\archive_tmp.txt".replace("\","\\") + "'" + " " + "into table soa_log.archive fields terminated by ':::;' lines terminated by '\n' (DiskSN,IP,MAC,Cname,Uname,datetime,src_root,src_directory,src_file,src_ext,arc_root,arc_directory,arc_file,arc_ext,curs);"
Invoke-MySqlQuery -Query $query
Invoke-MySqlQuery -query "select * from soa_log.archive order by id desc limit 1;"
Remove-Item "C:\backlog\filter\archive_tmp.txt" -Force
#$squery.Dispose()
#$src_outfile.Dispose()
#$compare.Dispose()
}


   <#
if (!(Test-Path("C:\backlog\filter")))
{new-item -Path "C:\backlog\filter" -ItemType Directory -Force}

if (!(Test-Path("C:\backlog\filter\archive_src.txt")))
{
$src_outfile | Out-File "C:\backlog\filter\archive_src.txt" -Append -Encoding utf8
$squery = "load data local infile" + " " + "'" + "C:\backlog\filter\archive_src.txt".replace("\","\\") + "'" + " " + "into table soa_log.archive_arc fields terminated by ':::;' lines terminated by '\n' (DiskSN,IP,MAC,Cname,Uname,datetime,root,directory,file,ext,curs);"
Invoke-MySqlQuery -Query $squery
Invoke-MySqlQuery -query "select * from soa_log.archive_src order by id desc limit 1;"
#$squery.Dispose()
}
elseif (Test-Path("C:\backlog\filter\archive_src.txt"))
{
$compare = Get-Content -Path "C:\backlog\filter\archive_src.txt"
$src_outfile | Where-Object {$_ -notin $compare} | Out-File "C:\backlog\filter\archive_src_tmp.txt" -Append -Encoding utf8
$src_outfile | Where-Object {$_ -notin $compare} | Out-File "C:\backlog\filter\archive_src.txt" -Append -Encoding utf8
$squery = "load data local infile" + " " + "'" + "C:\backlog\filter\archive_src_tmp.txt".replace("\","\\") + "'" + " " + "into table soa_log.archive_src fields terminated by ':::;' lines terminated by '\n' (DiskSN,IP,MAC,Cname,Uname,datetime,root,directory,file,ext,curs);"
Invoke-MySqlQuery -Query $squery
Invoke-MySqlQuery -query "select * from soa_log.rfile_mod order by id desc limit 1;"
Remove-Item "C:\backlog\filter\archive_src_tmp.txt" -Force
#$squery.Dispose()
#$src_outfile.Dispose()
#$compare.Dispose()
}
   
   #>
    <#
 $zip_outfile = $ziptime.DiskSN + ":::;"+ $ziptime.IP + ":::;"+ $ziptime.MAC + ":::;"+ $ziptime.cname + ":::;"+ $ziptime.uname + ":::;"+ $ziptime.datetime + ":::;"+ $ziptime.root + ":::;"+ $ziptime.directory + ":::;"+ $ziptime.file + ":::;"+ $ziptime.ext + ":::;"

 $zip_outfile | Out-File "C:\backlog\filter\archive_arc.txt" -Append -Encoding utf8
$zquery = "load data local infile" + " " + "'" + "C:\backlog\filter\archive_arc.txt".replace("\","\\") + "'" + " " + "into table soa_log.archive_arc fields terminated by ':::;' lines terminated by '\n' (DiskSN,IP,MAC,Cname,Uname,datetime,root,directory,file,ext,curs);"
Invoke-MySqlQuery -Query $zquery
Invoke-MySqlQuery -query "select * from soa_log.archive_arc order by id desc limit 1;"
 Remove-Item "C:\backlog\filter\archive_arc.txt" -Force 
    
 <#
if (!(Test-Path("C:\backlog\filter")))
{new-item -Path "C:\backlog\filter" -ItemType Directory -Force}

if (!(Test-Path("C:\backlog\filter\archive_arc.txt")))
{
$zip_outfile | Out-File "C:\backlog\filter\archive_arc.txt" -Append -Encoding utf8
$zquery = "load data local infile" + " " + "'" + "C:\backlog\filter\archive_arc.txt".replace("\","\\") + "'" + " " + "into table soa_log.archive_arc fields terminated by ':::;' lines terminated by '\n' (DiskSN,IP,MAC,Cname,Uname,datetime,root,directory,file,ext, curs);"
Invoke-MySqlQuery -Query $zquery
Invoke-MySqlQuery -query "select * from soa_log.archive_arc order by id desc limit 1;"
#$zquery.Dispose()
}
elseif (Test-Path("C:\backlog\filter\archive_arc.txt"))
{
$compare = Get-Content -Path "C:\backlog\filter\archive_arc.txt"
$zip_outfile | Where-Object {$_ -notin $compare} | Out-File "C:\backlog\filter\archive_arc_tmp.txt" -Append -Encoding utf8
$zip_outfile | Where-Object {$_ -notin $compare} | Out-File "C:\backlog\filter\archive_arc.txt" -Append -Encoding utf8
$zquery = "load data local infile" + " " + "'" + "C:\backlog\filter\archive_arc_tmp.txt".replace("\","\\") + "'" + " " + "into table soa_log.archive_arc fields terminated by ':::;' lines terminated by '\n' (DiskSN,IP,MAC,Cname,Uname,datetime,root,directory,file,ext, curs);"
Invoke-MySqlQuery -Query $zquery
Invoke-MySqlQuery -query "select * from soa_log.archive_arc order by id desc limit 1;"
Remove-Item "C:\backlog\filter\archive_arc_tmp.txt" -Force
#$zquery.Dispose()
#$zip_outfile.Dispose()
#$compare.Dispose()
}     #> 
 
 
    #>
    }
} 
}
}
}
$conn.close()

#DiskSN, IP, MAC, cname, uname, root, directory, datetime, file, ext