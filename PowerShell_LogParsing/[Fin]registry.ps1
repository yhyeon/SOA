$usbpath = 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\enum\usb\*\*', 'Registry::HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\enum\usbstor\*\*'
$reg = get-childitem $usbpath
foreach($usb in $reg)
{
$devicedesc = ($usb | ForEach-Object {Get-ItemProperty $_.pspath} | select devicedesc).devicedesc
$hardwareid = ($usb | ForEach-Object {Get-ItemProperty $_.pspath} | select hardwareid).hardwareid[0]
$compatibleids = ($usb | ForEach-Object {Get-ItemProperty $_.pspath} | select compatibleids).compatibleids[0]
$driver = ($usb | ForEach-Object {Get-ItemProperty $_.pspath} | select driver).driver
$mfg = ($usb | ForEach-Object {Get-ItemProperty $_.pspath} | select mfg).mfg
$service = ($usb | ForEach-Object {Get-ItemProperty $_.pspath} | select service).service
$friendlyname = ($usb | ForEach-Object {Get-ItemProperty $_.pspath} | select friendlyname).friendlyname
$label = ($usb | ForEach-Object {Get-ItemProperty $_.pspath} | select label).label
$lifetiemid = ($usb | ForEach-Object {Get-ItemProperty $_.pspath} | select lifetimeid).lifetimeid
$devicedesc + ":::;" + $hardwareid + ":::;" + $compatibleids + ":::;" + $driver + ":::;" + $mfg + ":::;" + $service + ":::;" + $friendlyname | Out-File  C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddHH)_reg.txt -Append 
}