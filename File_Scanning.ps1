$ErrorActionPreference = 'silentlycontinue'
$env:hostIP = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.netadapter.status -ne "Disconnected"}).ipv4address.ipaddress
$env:hostMAC = (Get-NetAdapter | where-object -FilterScript {$_.ifDesc -match "Intel*"}).MacAddress
get-psdrive | select root `
| % {get-childitem $_.Root -file -recurse `
| foreach {$env:username + " : " + $env:userdomain + " : " + $env:COMPUTERNAME + " : " + $env:hostIP + " : " + $env:hostMAC + " : " + $_.CreationTime + " : " + $_.LastAccessTime + “ : “ + $_.lastwritetime + " : " + "{0:N2}" -f ($_.Length/1kb) + " : " + $_.DirectoryName + " : " + $_.Name}  | Out-File  C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhhmm).txt -Append }
