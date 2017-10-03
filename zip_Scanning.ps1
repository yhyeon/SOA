$ErrorActionPreference = 'silentlycontinue'

[Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem')
$env:hostIP = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.netadapter.status -ne "Disconnected"}).ipv4address.ipaddress
$env:hostMAC = (Get-NetAdapter | where-object -FilterScript {$_.HardwareInterface -eq "True" -and $_.Status -ne "Disconnected"}).MacAddress
get-psdrive | select root `
|% {foreach($sourceFile in (Get-ChildItem $_.Root -recurse -file -Filter '*.zip'))
{
[IO.Compression.ZipFile]::OpenRead($sourceFile.FullName).Entries | %{$env:username + " : " + $env:userdomain + " : " + $env:COMPUTERNAME + " : " + $env:hostIP + " : " + $env:hostMAC + " : " + $sourcefile.CreationTime + " : " + $sourcefile.LastAccessTime + “ : “ + $sourcefile.lastwritetime + " : " + "{0:N2}" -f ($_.Length/1kb) + " : "  + $sourcefile.directoryName + " : " + "$sourcefile`: $($_.FullName): $($_.Length)";} | Out-File C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhhmm)_zip.txt -Append
}}
