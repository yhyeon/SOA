[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
$enc = get-content C:\Windows\enp.txt | ConvertTo-SecureString
$user = "root"
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)

$conn = Connect-MySqlServer -Credential $cred 192.168.0.21 -Port 3306 -Database soa_log
#$connstr = "server=192.168.0.21;Port=3306; uid=root; pwd =236p@ssw0rd; Database=soa_log"
#$conn = New-Object MySql.Data.MySqlClient.MySqlConnection($connstr)
$conn.open()

$query = "select * from oafile where file is not null;"
$cmd = New-Object MySql.Data.MySqlClient.MySqlCommand($query, $conn)
$dataadapter = New-Object MySql.Data.MySqlClient.MySqlDataAdapter($cmd)
$dataset = New-Object system.data.dataset
$recordcount = $dataadapter.fill($dataset, "oafile")
$qresult = $dataset.Tables["oafile"]



$exreadattributes = ($qresult | Where-Object {($_.accessmask -eq "readattributes") -and ($_.PSname -eq "C:/Windows/explorer.exe")} | select datetime, file)

$exreadcontrol = ($qresult | Where-Object {($_.accessmask -eq "READ_CONTROL") -and ($_.PSname -eq "C:/Windows/explorer.exe")} | select datetime, file)

$exreaddata = ($qresult | Where-Object {($_.accessmask -eq "ReadData (or ListDirectory)") -and ($_.PSname -eq "C:/Windows/explorer.exe")} | select datetime, file)

$exwritedata = ($qresult | Where-Object {($_.accessmask -eq "WriteData (or AddFile)") -and ($_.PSname -eq "C:/Windows/explorer.exe")} | select datetime, file)

$bfile = ($qresult | Where-Object {($_.accessmask -eq "DELETE") -and ($_.PSname -eq "C:/Windows/explorer.exe")} | Where-Object {($_.datetime -in $exreadattributes.datetime) -and ($_.file -in $exreadattributes.file)} | Where-Object {$_.file -in $exreadcontrol.file} | select DiskSN, IP, MAC, cname, uname, datetime, sid, logonid, dname, objserver, root, directory, file, ext, psname)

$exdelete = ($qresult | Where-Object {($_.accessmask -eq "DELETE") -and ($_.PSname -eq "C:/Windows/explorer.exe")} | select datetime, file)

$afile = ($qresult | Where-Object {($_.accessmask -eq "READ_CONTROL") -and ($_.PSname -eq "C:/Windows/System32/SearchProtocolHost.exe")} | Where-Object {($_.datetime -in $spreadattributes.datetime) -and ($_.file -in $spreadattributes.file)} | Where-Object {($_.datetime -in $exdelete.datetime)} | select DiskSN, IP, MAC, cname, uname, datetime, sid, logonid, dname, objserver, root, directory, file, ext, psname)

$spreadcontrol = ($qresult | Where-Object {($_.accessmask -eq "READ_CONTROL") -and ($_.PSname -eq "C:/Windows/System32/SearchProtocolHost.exe")} | select datetime, file)

$spreadattributes = ($qresult | Where-Object {($_.accessmask -eq "ReadAttributes") -and ($_.PSname -eq "C:/Windows/System32/SearchProtocolHost.exe")} | select datetime, file)

$spreaddata = ($qresult | Where-Object {($_.accessmask -eq "ReadData (or ListDirectory)") -and ($_.PSname -eq "C:/Windows/System32/SearchProtocolHost.exe")} | select datetime, file)

$num = $bfile.file.count

for ($i = 0; $i -lt $num; $i++)
{
$outfile = $bfile[$i].disksn + ":::;" +  $binfo[$i].ip + ":::;" + $bfile[$i].mac+ ":::;" + $bfile[$i].cname + ":::;" + $bfile[$i].uname+ ":::;" + $bfile[$i].datetime + ":::;" + $bfile[$i].root + ":::;" + $bfile[$i].directory + ":::;" + $bfile[$i].file + ":::;" + $bfile[$i].ext + ":::;" + $afile[$i].root + ":::;" + $afile[$i].directory + ":::;" + $afile[$i].file + ":::;" + $afile[$i].ext + ":::;"

if (!(Test-Path("C:\backlog\filter")))
{new-item -Path "C:\backlog\filter" -ItemType Directory -Force}

if (!(Test-Path("C:\backlog\filter\rfile.txt")))
{

$outfile | Out-File "C:\backlog\filter\rfile.txt" -Append -Encoding utf8
$query = "load data local infile" + " " + "'" + "C:\backlog\filter\rfile.txt".replace("\","\\") + "'" + " " + "into table soa_log.rfile fields terminated by ':::;' lines terminated by '\n' (DiskSN,IP,MAC,Cname,Uname,datetime,ori_root,ori_directory,ori_file,ori_ext,mod_root,mod_directory,mod_file,mod_ext,curs);"
Invoke-MySqlQuery -Query $query
Invoke-MySqlQuery -query "select * from soa_log.rfile order by id desc limit 1;"
}
elseif (Test-Path("C:\backlog\filter\rfile.txt"))
{
$compare = Get-Content -Path "C:\backlog\filter\rfile.txt"
$outfile | Where-Object {$_ -notin $compare} | Out-File "C:\backlog\filter\rfile_tmp.txt" -Append -Encoding utf8
$outfile | Where-Object {$_ -notin $compare} | Out-File "C:\backlog\filter\rfile.txt" -Append -Encoding utf8
$query = "load data local infile" + " " + "'" + "C:\backlog\filter\rfile_tmp.txt".replace("\","\\") + "'" + " " + "into table soa_log.rfile fields terminated by ':::;' lines terminated by '\n' (DiskSN,IP,MAC,Cname,Uname,datetime,ori_root,ori_directory,ori_file,ori_ext,mod_root,mod_directory,mod_file,mod_ext,curs);"
Invoke-MySqlQuery -Query $query
Invoke-MySqlQuery -query "select * from soa_log.rfile order by id desc limit 1;"
Remove-Item "C:\backlog\filter\rfile_tmp.txt" -Force
#$squery.Dispose()
#$ori_outfile.Dispose()
#$compare.Dispose()
}
}

$conn.close()