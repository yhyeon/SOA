$ErrorActionPreference = 'silentlycontinue'
$IP = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.netadapter.status -ne "Disconnected"}).ipv4address.ipaddress
$MAC = (Get-NetAdapter | where-object -FilterScript {$_.HardwareInterface -eq "True" -and $_.Status -ne "Disconnected"}).MacAddress
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
$ip + ":::;" + $mac + ":::;" + $devicedesc + ":::;" + $hardwareid + ":::;" + $compatibleids + ":::;" + $driver + ":::;" + $mfg + ":::;" + $service + ":::;" + $friendlyname | Out-File  C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHH)_reg.txt -Append 
}
