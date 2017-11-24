[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
$connstr = "server=192.168.0.21;Port=3306; uid=root; pwd =236p@ssw0rd; Database=soa_log"
$conn = New-Object MySql.Data.MySqlClient.MySqlConnection($connstr)
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
if ($result | Where-Object {($_.accessmask -eq "[void][System.Reflection.Assembly]::LoadWithPartialName("MySql.Data")
$connstr = "server=192.168.0.21;Port=3306; uid=root; pwd =236p@ssw0rd; Database=soa_log"
$conn = New-Object MySql.Data.MySqlClient.MySqlConnection($connstr)
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
$result
#$result.file
}
}

if ($result | Where-Object {($_.accessmask -eq "READ_CONTROL") -and ($_.PSname -eq "C:/Windows/System32/SearchProtocolHost.exe")} | Where-Object {($_.datetime -in $spreadattributes.datetime) -and ($_.file -in $spreadattributes.file)})
{

#if ($result | Where-Object {($_.accessmask -eq "READ_CONTROL") -and ($_.PSname -eq "C:/Windows/System32/SearchProtocolHost.exe")} | Where-Object {($_.datetime -in $spreaddata.datetime) -and ($_.file -in $spreaddata.file)})
#{

if ($result | Where-Object {($_.accessmask -eq "READ_CONTROL") -and  ($_.PSname -eq "C:/Windows/System32/SearchProtocolHost.exe")} | Where-Object {($_.datetime -in $exdelete.datetime)})

{
#$result.file
$result
}
#}
}

}
}
$conn.close()

DELETE") -and ($_.PSname -eq "C:/Windows/explorer.exe")} | Where-Object {$_.file -in $exreadcontrol.file})
{
$result.file
}
}

if ($result | Where-Object {($_.accessmask -eq "READ_CONTROL") -and ($_.PSname -eq "C:/Windows/System32/SearchProtocolHost.exe")} | Where-Object {($_.datetime -in $spreadattributes.datetime) -and ($_.file -in $spreadattributes.file)})
{

#if ($result | Where-Object {($_.accessmask -eq "READ_CONTROL") -and ($_.PSname -eq "C:/Windows/System32/SearchProtocolHost.exe")} | Where-Object {($_.datetime -in $spreaddata.datetime) -and ($_.file -in $spreaddata.file)})
#{

if ($result | Where-Object {($_.accessmask -eq "READ_CONTROL") -and  ($_.PSname -eq "C:/Windows/System32/SearchProtocolHost.exe")} | Where-Object {($_.datetime -in $exdelete.datetime)})

{
#$result.file
}
#}
}

}
}
$conn.close()

