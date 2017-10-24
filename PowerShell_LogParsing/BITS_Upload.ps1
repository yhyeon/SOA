$ErrorActionPreference = 'silentlycontinue'
Import-Module bitstransfer
$enc = Get-Content C:\Windows\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "C:\Users\Public\Documents\" # directory in which files to be sent
Get-ChildItem -path $src |
foreach {
$dst = "http://192.168.1.50/soa/upload/$($_.name)" # server directory with write permissions
$job = Start-BitsTransfer -source $($_.FullName) -Destination $dst -Credential $cred -TransferType Upload -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 10;}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
"Error" {$job | Format-List}
}
}
