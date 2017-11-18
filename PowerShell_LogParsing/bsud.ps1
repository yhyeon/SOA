$sw = [System.Diagnostics.Stopwatch]::startnew()
$ErrorActionPreference = 'silentlycontinue'

$src = "C:\ProgramData\soalog\*_dscanfiles.txt", "C:\ProgramData\soalog\*_dscanzip.txt", "C:\ProgramData\soalog\*_dscanquicks.txt", "C:\ProgramData\soalog\*_dscanpart.txt"
Get-ChildItem -path $src |
foreach {

if ($($_.Length) -eq "0")
{
Remove-Item $($_.FullName) -Force
}

if ($($_.name) -match "files.txt")
{

if (!(Test-Path "C:\ProgramData\soalog\df.txt"))
{
get-content $($_.FullName) | Out-File $($_.FullName).replace("dscanfiles","files") -Append -Encoding UTF8
Remove-Item $($_.FullName) -Force
}
else
{
$fcompare = get-content "C:\ProgramData\soalog\df.txt"
get-content $($_.FullName) | Where-Object {$_ -notin $fcompare} | Out-File $($_.FullName).replace("dscanfiles","files") -Append -Encoding UTF8
Remove-Item $($_.FullName) -Force
$fcompare.Dispose()
}
}

if ($($_.name) -match "zip.txt")
{

if (!(Test-Path "C:\ProgramData\soalog\dz.txt"))
{
get-content $($_.FullName) | Out-File $($_.FullName).replace("dscanzip","zip") -Append -Encoding UTF8
Remove-Item $($_.FullName) -Force
}
else
{
$zcompare = get-content "C:\ProgramData\soalog\dz.txt"
get-content $($_.FullName) | Where-Object {$_ -notin $zcompare} | Out-File $($_.FullName).replace("dscanzip","zip") -Append -Encoding UTF8
Remove-Item $($_.FullName) -Force
$zcompare.Dispose()
}
}

if ($($_.name) -match "quicks.txt")
{

if (!(Test-Path "C:\ProgramData\soalog\dq.txt"))
{
get-content $($_.FullName) | Out-File $($_.FullName).replace("dscanquicks","quicks") -Append -Encoding UTF8
Remove-Item $($_.FullName) -Force
}
else
{
$qcompare = get-content "C:\ProgramData\soalog\dq.txt"
get-content $($_.FullName) | Where-Object {$_ -notin $qcompare} | Out-File $($_.FullName).replace("dscanquicks","quicks") -Append -Encoding UTF8
Remove-Item $($_.FullName) -Force
$qcompare.Dispose()
}
}

if ($($_.name) -match "part.txt")
{

if (!(Test-Path "C:\ProgramData\soalog\p.txt"))
{
get-content $($_.FullName) | Out-File $($_.FullName).replace("dscanpart","partition") -Append -Encoding UTF8
Remove-Item $($_.FullName) -Force
}
else
{
$pcompare = get-content "C:\ProgramData\soalog\p.txt"
get-content $($_.FullName) | Where-Object {$_ -notin $pcompare} | Out-File $($_.FullName).replace("dscanpart","partition") -Append -Encoding UTF8
Remove-Item $($_.FullName) -Force
$pcompare.Dispose()
}

}
}

Import-Module bitstransfer
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
#$src = "C:\ProgramData\soalog\" # directory in which files to be sent
$src = "C:\ProgramData\soalog\*_quicks.txt", "C:\ProgramData\soalog\*_files.txt", "C:\ProgramData\soalog\*_zip.txt", "C:\ProgramData\soalog\*_partition.txt"
Get-ChildItem -path $src |
foreach {
$dst = "http://cdisc.co.kr:1024/soa/upload/$($_.name)" # server directory with write permissions
$job = Start-BitsTransfer -source $($_.FullName) -Destination $dst -Credential $cred -TransferType Upload -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 10;}
if ($job.JobState -eq "Transferred")
{
if ($($_.name) -match "files.txt")
{
get-content $($_.FullName) | Out-File "C:\ProgramData\soalog\df.txt" -Append -Encoding UTF8
Remove-Item $($_.FullName) -Force
}

if ($($_.name) -match "zip.txt")
{
get-content $($_.FullName) | Out-File "C:\ProgramData\soalog\dz.txt" -Append -Encoding UTF8
Remove-Item $($_.FullName) -Force
}

if ($($_.name) -match "quicks.txt")
{
get-content $($_.FullName) | Out-File "C:\ProgramData\soalog\dq.txt" -Append -Encoding UTF8
Remove-Item $($_.FullName) -Force
}

if ($($_.name) -match "partition.txt")
{
get-content $($_.FullName) | Out-File "C:\ProgramData\soalog\p.txt" -Append -Encoding UTF8
Remove-Item $($_.FullName) -Force
}
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

$sw.stop()
$sw.Elapsed.tostring('dd\.hh\"mm\:ss\.fff')