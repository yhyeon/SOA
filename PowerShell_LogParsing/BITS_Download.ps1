Import-Module bitstransfer
$enc = Get-Content C:\Windows\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://192.168.1.50/SOA/download/registry.ps1"
$dst = "C:\windows\registry.ps1"
$job = Start-BitsTransfer -source $src -Destination $dst -Credential $cred -TransferType download -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 5;}

Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
"Error" {$job | Format-List}
}
