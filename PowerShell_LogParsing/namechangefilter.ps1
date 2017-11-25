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

$exdelete = ($qresult | Where-Object {($_.accessmask -eq "DELETE") -and ($_.PSname -eq "C:/Windows/explorer.exe")} | select datetime, file)

$spreadcontrol = ($qresult | Where-Object {($_.accessmask -eq "READ_CONTROL") -and ($_.PSname -eq "C:/Windows/System32/SearchProtocolHost.exe")} | select datetime, file)

$spreadattributes = ($qresult | Where-Object {($_.accessmask -eq "ReadAttributes") -and ($_.PSname -eq "C:/Windows/System32/SearchProtocolHost.exe")} | select datetime, file)

$spreaddata = ($qresult | Where-Object {($_.accessmask -eq "ReadData (or ListDirectory)") -and ($_.PSname -eq "C:/Windows/System32/SearchProtocolHost.exe")} | select datetime, file)



foreach ($result in $qresult)
{

if ($result.root -notmatch "DeviceHarddiskVolume")
{
if ($result | Where-Object {($_.accessmask -eq "DELETE") -and ($_.PSname -eq "C:/Windows/explorer.exe")} | Where-Object {($_.datetime -in $exreadattributes.datetime) -and ($_.file -in $exreadattributes.file)})
{
if ($result | Where-Object {($_.accessmask -eq "DELETE") -and ($_.PSname -eq "C:/Windows/explorer.exe")} | Where-Object {$_.file -in $exreadcontrol.file})
{
$binfo = ($result | select DiskSN, IP, MAC, accessmask, eventid, cname, uname, datetime, sid, logonid, dname, objserver, root, directory, file, ext, psname)
$binfo_disksn = $binfo.DiskSN
$binfo_ip = $binfo.IP
$binfo_mac = $binfo.MAC
$binfo_accessmask = $binfo.accessmask
$binfo_eventid = $binfo.eventid
$binfo_cname = $binfo.Cname
$binfo_uname = $binfo.Uname
$binfo_datetime = $binfo.datetime
$binfo_sid = $binfo.SID
$binfo_logonid = $binfo.logonid
$binfo_dname = $binfo.dname
$binfo_objserver = $binfo.objserver
$binfo_root = $binfo.root
$binfo_dir = $binfo.directory
$binfo_file = $binfo.file
$binfo_ext = $binfo.ext
$binfo_psname = $binfo.psname

$binfo_outfile = $binfo_disksn + ":::;" + $binfo_ip + ":::;" + $binfo_mac + ":::;" + $binfo_accessmask + ":::;" + $binfo_eventid + ":::;" + $binfo_cname + ":::;" + $binfo_uname + ":::;" + $binfo_datetime + ":::;" + $binfo_sid + ":::;" + $binfo_logonid + ":::;" + $binfo_dname + ":::;" + $binfo_objserver + ":::;" + $binfo_dname + ":::;" + $binfo_objserver + ":::;" + $binfo_root + ":::;" + $binfo_dir + ":::;" + $binfo_file + ":::;" + $binfo_ext + ":::;" + $binfo_psname + ":::;"

if (!(Test-Path("C:\backlog\filter")))
{new-item -Path "C:\backlog\filter" -ItemType Directory -Force}

if (!(Test-Path("C:\backlog\filter\rfile_ori.txt")))
{
$binfo_outfile | Out-File "C:\backlog\filter\rfile_ori.txt" -Append -Encoding utf8
$bquery = "load data local infile" + " " + "'" + "C:\backlog\filter\rfile_ori.txt".replace("\","\\") + "'" + " " + "into table soa_log.rfile_ori fields terminated by ':::;' lines terminated by '\n' (DiskSN,IP,MAC,accessmask,eventID,Cname,Uname,datetime,SID,logonID,Dname,objserver,root,directory,file,ext,PSname,curs);"
Invoke-MySqlQuery -Query $bquery
Invoke-MySqlQuery -query "select * from soa_log.rfile_ori order by id desc limit 1;"
#$bquery.Dispose()
}
elseif (Test-Path("C:\backlog\filter\rfile_ori.txt"))
{
$compare = Get-Content -Path "C:\backlog\filter\rfile_ori.txt"
$binfo_outfile | Where-Object {$_ -notin $compare} | Out-File "C:\backlog\filter\rfile_ori_tmp.txt" -Append -Encoding utf8
$binfo_outfile | Where-Object {$_ -notin $compare} | Out-File "C:\backlog\filter\rfile_ori.txt" -Append -Encoding utf8
$bquery = "load data local infile" + " " + "'" + "C:\backlog\filter\rfile_ori_tmp.txt".replace("\","\\") + "'" + " " + "into table soa_log.rfile_ori fields terminated by ':::;' lines terminated by '\n' (DiskSN,IP,MAC,accessmask,eventID,Cname,Uname,datetime,SID,logonID,Dname,objserver,root,directory,file,ext,PSname,curs);"
Invoke-MySqlQuery -Query $bquery
Invoke-MySqlQuery -query "select * from soa_log.rfile_mod order by id desc limit 1;"
Remove-Item "C:\backlog\filter\rfile_ori_tmp.txt" -Force
#$bquery.Dispose()
#$binfo_outfile.Dispose()
#$compare.Dispose()
}
<#
$binfo_outfile.Dispose()
$binfo_disksn.Dispose()
$binfo_ip.Dispose()
$binfo_mac.Dispose()
$binfo_accessmask.Dispose()
$binfo_eventid.Dispose()
$binfo_cname.Dispose()
$binfo_uname.Dispose()
$binfo_datetime.Dispose()
$binfo_sid.Dispose()
$binfo_logonid.Dispose()
$binfo_dname.Dispose()
$binfo_objserver.Dispose()
$binfo_root.Dispose()
$binfo_dir.Dispose()
$binfo_file.Dispose()
$binfo_ext.Dispose()
$binfo_psname.Dispose()
$binfo.Dispose()
#>
}
}

if ($result | Where-Object {($_.accessmask -eq "READ_CONTROL") -and ($_.PSname -eq "C:/Windows/System32/SearchProtocolHost.exe")} | Where-Object {($_.datetime -in $spreadattributes.datetime) -and ($_.file -in $spreadattributes.file)})
{

if ($result | Where-Object {($_.accessmask -eq "READ_CONTROL") -and  ($_.PSname -eq "C:/Windows/System32/SearchProtocolHost.exe")} | Where-Object {($_.datetime -in $exdelete.datetime)})

{
$ainfo = ($result | select DiskSN, IP, MAC, accessmask, eventid, cname, uname, datetime, sid, logonid, dname, objserver, root, directory, file, ext, psname)
$ainfo_disksn = $ainfo.DiskSN
$ainfo_ip = $ainfo.IP
$ainfo_mac = $ainfo.MAC
$ainfo_accessmask = $ainfo.accessmask
$ainfo_eventid = $ainfo.eventid
$ainfo_cname = $ainfo.Cname
$ainfo_uname = $ainfo.Uname
$ainfo_datetime = $ainfo.datetime
$ainfo_sid = $ainfo.SID
$ainfo_logonid = $ainfo.logonid
$ainfo_dname = $ainfo.dname
$ainfo_objserver = $ainfo.objserver
$ainfo_root = $ainfo.root
$ainfo_dir = $ainfo
$ainfo_file = $ainfo.file
$ainfo_ext = $ainfo.ext
$ainfo_psname = $ainfo.psname

$ainfo_outfile = $ainfo_disksn + ":::;" + $ainfo_ip + ":::;" + $ainfo_mac + ":::;" + $ainfo_accessmask + ":::;" + $ainfo_eventid + ":::;" + $ainfo_cname + ":::;" + $ainfo_uname + ":::;" + $ainfo_datetime + ":::;" + $ainfo_sid + ":::;" + $ainfo_logonid + ":::;" + $ainfo_dname + ":::;" + $ainfo_objserver + ":::;" + $ainfo_dname + ":::;" + $ainfo_objserver + ":::;" + $ainfo_root + ":::;" + $ainfo_dir + ":::;" + $ainfo_file + ":::;" + $ainfo_ext + ":::;" + $ainfo_psname + ":::;"



if (!(Test-Path("C:\backlog\filter")))
{new-item -Path "C:\backlog\filter" -ItemType Directory -Force}

if (!(Test-Path("C:\backlog\filter\rfile_mod.txt")))
{
$ainfo_outfile | Out-File "C:\backlog\filter\rfile_mod.txt" -Append -Encoding utf8
$aquery = "load data local infile" + " " + "'" + "C:\backlog\filter\rfile_mod.txt".replace("\","\\") + "'" + " " + "into table soa_log.rfile_mod fields terminated by ':::;' lines terminated by '\n' (DiskSN,IP,MAC,accessmask,eventID,Cname,Uname,datetime,SID,logonID,Dname,objserver,root,directory,file,ext,PSname,curs);"
Invoke-MySqlQuery -Query $aquery
Invoke-MySqlQuery -query "select * from soa_log.rfile_mod order by id desc limit 1;"
#$aquery.Dispose()
}
elseif (Test-Path("C:\backlog\filter\rfile_mod.txt"))
{
$compare = Get-Content -Path "C:\backlog\filter\rfile_mod.txt"
$ainfo_outfile | Where-Object {$_ -notin $compare} | Out-File "C:\backlog\filter\rfile_mod_tmp.txt" -Append -Encoding utf8
$ainfo_outfile | Where-Object {$_ -notin $compare} | Out-File "C:\backlog\filter\rfile_mod.txt" -Append -Encoding utf8
$aquery = "load data local infile" + " " + "'" + "C:\backlog\filter\rfile_mod_tmp.txt".replace("\","\\") + "'" + " " + "into table soa_log.rfile_mod fields terminated by ':::;' lines terminated by '\n' (DiskSN,IP,MAC,accessmask,eventID,Cname,Uname,datetime,SID,logonID,Dname,objserver,root,directory,file,ext,PSname,curs);"
Invoke-MySqlQuery -Query $aquery
Invoke-MySqlQuery -query "select * from soa_log.rfile_mod order by id desc limit 1;"
Remove-Item "C:\backlog\filter\rfile_mod_tmp.txt" -Force
#$aquery.Dispose()
#$ainfo_outfile.Dispose()
#$compare.Dispose()
}
<#
$ainfo_outfile.Dispose()
$ainfo_disksn.Dispose()
$ainfo_ip.Dispose()
$ainfo_mac.Dispose()
$ainfo_accessmask.Dispose()
$ainfo_eventid.Dispose()
$ainfo_cname.Dispose()
$ainfo_uname.Dispose()
$ainfo_datetime.Dispose()
$ainfo_sid.Dispose()
$ainfo_logonid.Dispose()
$ainfo_dname.Dispose()
$ainfo_objserver.Dispose()
$ainfo_root.Dispose()
$ainfo_dir.Dispose()
$ainfo_file.Dispose()
$ainfo_ext.Dispose()
$ainfo_psname.Dispose()
$ainfo.Dispose()
#>
}
#}
}


}
}
$conn.close()

