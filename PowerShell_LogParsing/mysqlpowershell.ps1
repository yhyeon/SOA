$sw = [System.Diagnostics.Stopwatch]::startnew()
$enc = get-content C:\Windows\enp.txt | ConvertTo-SecureString
$user = "elastic"
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$conn = Connect-MySqlServer -Credential $cred 192.168.0.21 -Port 3306 -Database soa_log -CommandTimeOut 86400 -ConnectionTimeOut 86400
$conn.Open()

$partpath = test-path "C:\soa\upload\*_partition.txt" # partition_win10
if ($partpath -like "True")
{
$partfdir = "C:\soa\upload\*_partition.txt"
$partfs = get-childitem -path $partfdir |
foreach {
$partitionquery =  "load data local infile" + " " + "'" + $($_.FullName).replace("\","\\") + "'" + " " + "into table soa_log.partition_win10 fields terminated by ':::;' lines terminated by '\n' (IP,MAC,Cname,SID,date,time,EventID,diskNum,diskID,characteristics,bustype,manufacturer,model,modelversion,SerialNum,parentID,registryID);"
Invoke-MySqlQuery -Query $partitionquery
Remove-Item $($_.FullName)
}
#Invoke-MySqlQuery -query "select * from soa_log.partition_win10;"
}


$regpath = test-path "C:\soa\upload\*_reg.txt" # registry
if ($regpath -like "True")
{
$regdir = "C:\soa\upload\*_reg.txt"
$regfs = get-childitem -path $regfdir |
foreach {
$regquery =  "load data local infile" + " " + "'" + $($_.FullName).replace("\","\\") + "'" + " " + "into table soa_log.registry fields terminated by ':::;' lines terminated by '\n' (IP,MAC,devicedesc,hardwareID,compatibleids,driver,mfg,service,friendlyname);"
Invoke-MySqlQuery -Query $regquery
Remove-Item $($_.FullName)
}
#Invoke-MySqlQuery -query "select * from soa_log.registry;"
}


$driverpath = test-path "C:\soa\upload\*_Win7Driver.txt" # driver
if ($driverpath -like "True")
{
$driverfdir = "C:\soa\upload\*_Win7Driver.txt"
$driverfs = get-childitem -path $driverfdir |
foreach {
$driverquery =  "load data local infile" + " " + "'" + $($_.FullName).replace("\","\\") + "'" + " " + "into table soa_log.driver fields terminated by ':::;' lines terminated by '\n' (IP,MAC,Cname,SID,date,time,EventID,lifetime,HostGUID,device,statusinfo);"
Invoke-MySqlQuery -Query $driverquery
Remove-Item $($_.FullName)
}
#Invoke-MySqlQuery -query "select * from soa_log.driver;"
}


$file_scanpath = test-path "C:\soa\upload\*_files.txt" # file_scan
if ($file_scanpath -like "True")
{
$file_scanfdir = "C:\soa\upload\*_files.txt"
$file_scanfs = get-childitem -path $file_scanfdir |
foreach {
$fscanquery =  "load data local infile" + " " + "'" + $($_.FullName).replace("\","\\") + "'" + " " + "into table soa_log.file_scan fields terminated by ':::;' lines terminated by '\n' (UDnme,Cname,IP,MAC,Uname,Cdate,Ctime,Adate,Atime,Mdate,Mtime,size_KB,rootdir,dirname,Fname,basename,ext,attrib);"
Invoke-MySqlQuery -Query $fscanquery
Remove-Item $($_.FullName)
}
#Invoke-MySqlQuery -query "select * from soa_log.file_scan;"
}


$logon_offpath = test-path "C:\soa\upload\*_logonoff.txt" # logon_off
if ($logon_offpath -like "True")
{
$logon_offfdir = "C:\soa\upload\*_logonoff.txt"
$logon_offfs = get-childitem -path $logon_offfdir |
foreach {
$logonoffquery =  "load data local infile" + " " + "'" + $($_.FullName).replace("\","\\") + "'" + " " + "into table soa_log.logon_off fields terminated by ':::;' lines terminated by '\n' (IP,MAC,logtype,eventID,ONOFFdate,ONOFFtime,Cname,SSID,SUname,SDname,SlogonID,TSID,TUname,TDname,TlogonID,failurecode);"
Invoke-MySqlQuery -Query $logonoffquery
Remove-Item $($_.FullName)
}
#Invoke-MySqlQuery -query "select * from soa_log.logon_off;"
}


$oa_mtppath = test-path "C:\soa\upload\*_oa_mtp.txt" # oa_mtp
if ($oa_mtppath -like "True")
{
$oa_mtpfdir = "C:\soa\upload\*_oa_mtp.txt"
$oa_mtpfs = get-childitem -path $oa_mtpfdir |
foreach {
$oa_mtpquery =  "load data local infile" + " " + "'" + $($_.FullName).replace("\","\\") + "'" + " " + "into table soa_log.oa_mtp fields terminated by ':::;' lines terminated by '\n' (IP,MAC,accessmask,eventID,Cname,Uname,date,time,SID,logonID,Dname,objserver,objname,ext,PSname);"
Invoke-MySqlQuery -Query $oa_mtpquery
Remove-Item $($_.FullName)
}
#Invoke-MySqlQuery -query "select * from soa_log.oa_mtp;"
}


$quick_scanpath = test-path "C:\soa\upload\*_quicks.txt" # quick_scan
if ($quick_scanpath -like "True")
{
$quick_scanfdir = "C:\soa\upload\*_quicks.txt"
$quick_scanfs = get-childitem -path $quick_scanfdir |
foreach {
$quick_scanquery =  "load data local infile" + " " + "'" + $($_.FullName).replace("\","\\") + "'" + " " + "into table soa_log.quick_scan fields terminated by ':::;' lines terminated by '\n' (UDname,Cname,IP,MAC,Uname,Fname,ext,Fnum);"
Invoke-MySqlQuery -Query $quick_scanquery
Remove-Item $($_.FullName)
}
#Invoke-MySqlQuery -query "select * from soa_log.quick_scan;"
}


$ZIP_scanpath = test-path "C:\soa\upload\*_zip.txt" # ZIP_scan
if ($ZIP_scanpath -like "True")
{
$ZIP_scanfdir = "C:\soa\upload\*_zip.txt"
$ZIP_scanfs = get-childitem -path $ZIP_scanfdir |
foreach {
$ZIP_scanquery =  "load data local infile" + " " + "'" + $($_.FullName).replace("\","\\") + "'" + " " + "into table soa_log.ZIP_scan fields terminated by ':::;' lines terminated by '\n' (UDname,Cname,IP,MAC,Uname,Cdate,Ctime,Adate,Atime,Mdate,Mtime,size_KB,rootdir,dirname,Fnamebasena,ext,attrib,srcna,srcext,srcsize);"
Invoke-MySqlQuery -Query $ZIP_scanquery
Remove-Item $($_.FullName)
}
#Invoke-MySqlQuery -query "select * from soa_log.ZIP_scan;"
}


$oa_logpath = test-path "C:\soa\upload\*_oa_filtered.txt" # oa_log
if ($partpath -like "True")
{
$oa_logdir = "C:\soa\upload\*_oa_filtered.txt"
$partfs = get-childitem -path $oa_logdir |
foreach {
$oa_logquery =  "load data local infile" + " " + "'" + $($_.FullName).replace("\","\\") + "'" + " " + "into table soa_log.oa_log fields terminated by ':::;' lines terminated by '\n' (IP,MAC,accessmask,eventID,Cname,Uname,date,time,SID,logonID,Dname,objserver,root,directory,file,ext,PSname);"
Invoke-MySqlQuery -Query $oa_logquery
Remove-Item $($_.FullName)
}
Invoke-MySqlQuery -query "select * from soa_log.oa_log;"
}


# web history required to be added.
