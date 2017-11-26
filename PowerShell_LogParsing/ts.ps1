# reg

if (!(Test-Path "C:\Windows\soa\reg.ps1"))
{
Import-Module bitstransfer
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://cdisc.co.kr:1024/soa/download/reg.ps1" # specify the web server directory
$dir = "C:\Windows\soa"
if(!(test-path $dir))
{new-item -Path "C:\Windows\soa" -ItemType Directory -Force }
$dst = "C:\Windows\soa\reg.ps1"
$job = Start-BitsTransfer -source $src -Destination $dst -Credential $cred -TransferType download -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 5;}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
}
$enc.Dispose()
$user.Dispose()
$cred.Dispose()
$src.Dispose()
$dir.Dispose()
$dst.Dispose()
$job.Dispose()
}

$jobname = "reg"
$script =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -mta -noprofile -file C:\Windows\soa\reg.ps1"
$action = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script"
$trigger = New-ScheduledTaskTrigger -AtLogOn -RandomDelay 00:00:30
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
$jobname.Dispose()
$script.Dispose()
$action.Dispose()
$trigger.Dispose()
$settings.Dispose()
$principal.Dispose()



# part

if (!(Test-Path "C:\Windows\soa\part.ps1"))
{
Import-Module bitstransfer
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://cdisc.co.kr:1024/soa/download/part.ps1" # specify the web server directory
$dir = "C:\Windows\soa"
if(!(test-path $dir))
{new-item -Path "C:\Windows\soa" -ItemType Directory -Force }
$dst = "C:\Windows\soa\part.ps1"
$job = Start-BitsTransfer -source $src -Destination $dst -Credential $cred -TransferType download -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 5;}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
}
$enc.Dispose()
$user.Dispose()
$cred.Dispose()
$src.Dispose()
$dir.Dispose()
$dst.Dispose()
$job.Dispose()
}

$jobname = "part"
$script =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -mta -noprofile -file C:\Windows\soa\part.ps1"
$action = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script"
$trigger = New-ScheduledTaskTrigger -AtLogOn -RandomDelay 00:00:35
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
$jobname.Dispose()
$script.Dispose()
$action.Dispose()
$trigger.Dispose()
$settings.Dispose()
$principal.Dispose()




# filter


if (!(Test-Path "C:\Windows\soa\filter.ps1"))
{
Import-Module bitstransfer
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://cdisc.co.kr:1024/soa/download/filter.ps1" # specify the web server directory
$dir = "C:\Windows\soa"
if(!(test-path $dir))
{new-item -Path "C:\Windows\soa" -ItemType Directory -Force }
$dst = "C:\Windows\soa\filter.ps1"
$job = Start-BitsTransfer -source $src -Destination $dst -Credential $cred -TransferType download -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 5;}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
}
$enc.Dispose()
$user.Dispose()
$cred.Dispose()
$src.Dispose()
$dir.Dispose()
$dst.Dispose()
$job.Dispose()
}

$jobname = "filter"
$script =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -mta -noprofile -file C:\Windows\soa\filter.ps1"
$action = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script"
$trigger = New-ScheduledTaskTrigger -AtLogon -RandomDelay 00:01:00
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
$jobname.Dispose()
$script.Dispose()
$action.Dispose()
$trigger.Dispose()
$settings.Dispose()
$principal.Dispose()




# logonoff / OA

if (!(Test-Path "C:\Windows\soa\sec.ps1"))
{
Import-Module bitstransfer
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://cdisc.co.kr:1024/soa/download/sec.ps1" # specify the web server directory
$dir = "C:\Windows\soa"
if(!(test-path $dir))
{new-item -Path "C:\Windows\soa" -ItemType Directory -Force }
$dst = "C:\Windows\soa\sec.ps1"
$job = Start-BitsTransfer -source $src -Destination $dst -Credential $cred -TransferType download -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 5;}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
}
$enc.Dispose()
$user.Dispose()
$cred.Dispose()
$src.Dispose()
$dir.Dispose()
$dst.Dispose()
$job.Dispose()
}

$jobname = "sec"
$script =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -mta -noprofile -file C:\Windows\soa\sec.ps1"
$action = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script"
$trigger = New-ScheduledTaskTrigger -AtLogon -RandomDelay 00:05:30
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
$jobname.Dispose()
$script.Dispose()
$action.Dispose()
$trigger.Dispose()
$settings.Dispose()
$principal.Dispose()





# filezip


if (!(Test-Path "C:\Windows\soa\filezip.ps1"))
{
Import-Module bitstransfer
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://cdisc.co.kr:1024/soa/download/filezip.ps1" # specify the web server directory
$dir = "C:\Windows\soa"
if(!(test-path $dir))
{new-item -Path "C:\Windows\soa" -ItemType Directory -Force }
$dst = "C:\Windows\soa\filezip.ps1"
$job = Start-BitsTransfer -source $src -Destination $dst -Credential $cred -TransferType download -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 5;}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
}
$enc.Dispose()
$user.Dispose()
$cred.Dispose()
$src.Dispose()
$dir.Dispose()
$dst.Dispose()
$job.Dispose()
}

$jobname = "filezip1"
$script =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -mta -noprofile -file C:\Windows\soa\filezip.ps1"
$action = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script"
$trigger = New-ScheduledTaskTrigger -Daily -At "10:00"
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
$jobname.Dispose()
$script.Dispose()
$action.Dispose()
$trigger.Dispose()
$settings.Dispose()
$principal.Dispose()

$jobname = "filezip2"
$script =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -mta -noprofile -file C:\Windows\soa\filezip.ps1"
$action = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script"
$trigger = New-ScheduledTaskTrigger -Daily -At "14:00"
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
$jobname.Dispose()
$script.Dispose()
$action.Dispose()
$trigger.Dispose()
$settings.Dispose()
$principal.Dispose()



# dscan

if (!(Test-Path "C:\Windows\soa\dscan.ps1"))
{
Import-Module bitstransfer
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://cdisc.co.kr:1024/soa/download/dscan.ps1" # specify the web server directory
$dir = "C:\Windows\soa"
if(!(test-path $dir))
{new-item -Path "C:\Windows\soa" -ItemType Directory -Force }
$dst = "C:\Windows\soa\dscan.ps1"
$job = Start-BitsTransfer -source $src -Destination $dst -Credential $cred -TransferType download -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 5;}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
}
$enc.Dispose()
$user.Dispose()
$cred.Dispose()
$src.Dispose()
$dir.Dispose()
$dst.Dispose()
$job.Dispose()
}

$jobname = "dscan"
$script =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -mta -noprofile -file C:\Windows\soa\dscan.ps1"
$action = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script"
$trigger = New-ScheduledTaskTrigger -AtLogon
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
$jobname.Dispose()
$script.Dispose()
$action.Dispose()
$trigger.Dispose()
$settings.Dispose()
$principal.Dispose()





# clipps

if (!(Test-Path "C:\Windows\soa\clips.ps1"))
{
Import-Module bitstransfer
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://cdisc.co.kr:1024/soa/download/clips.ps1" # specify the web server directory
$dir = "C:\Windows\soa"
if(!(test-path $dir))
{new-item -Path "C:\Windows\soa" -ItemType Directory -Force }
$dst = "C:\Windows\soa\clips.ps1"
$job = Start-BitsTransfer -source $src -Destination $dst -Credential $cred -TransferType download -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 5;}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
}
$enc.Dispose()
$user.Dispose()
$cred.Dispose()
$src.Dispose()
$dir.Dispose()
$dst.Dispose()
$job.Dispose()
}

$jobname = "clips"
$script =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -mta -noprofile -file C:\Windows\soa\clips.ps1"
$action = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script"
$trigger = New-ScheduledTaskTrigger -AtLogon
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
$jobname.Dispose()
$script.Dispose()
$action.Dispose()
$trigger.Dispose()
$settings.Dispose()
$principal.Dispose()




# bsud

if (!(Test-Path "C:\Windows\soa\bsud.ps1"))
{
Import-Module bitstransfer
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://cdisc.co.kr:1024/soa/download/bsud.ps1" # specify the web server directory
$dir = "C:\Windows\soa"
if(!(test-path $dir))
{new-item -Path "C:\Windows\soa" -ItemType Directory -Force }
$dst = "C:\Windows\soa\bsud.ps1"
$job = Start-BitsTransfer -source $src -Destination $dst -Credential $cred -TransferType download -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 5;}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
}
$enc.Dispose()
$user.Dispose()
$cred.Dispose()
$src.Dispose()
$dir.Dispose()
$dst.Dispose()
$job.Dispose()
}

$jobname = "bsud"
$script =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -mta -noprofile -file C:\Windows\soa\bsud.ps1"
$action = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script"
$trigger = New-ScheduledTaskTrigger -Daily -At "11:00"
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
$jobname.Dispose()
$script.Dispose()
$action.Dispose()
$trigger.Dispose()
$settings.Dispose()
$principal.Dispose()

$jobname = "bsud2"
$script =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -mta -noprofile -file C:\Windows\soa\bsud.ps1"
$action = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script"
$trigger = New-ScheduledTaskTrigger -Daily -At "14:00"
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
$jobname.Dispose()
$script.Dispose()
$action.Dispose()
$trigger.Dispose()
$settings.Dispose()
$principal.Dispose()


# bsud_rt (clipproc)

if (!(Test-Path "C:\Windows\soa\bsud_rt.ps1"))
{
Import-Module bitstransfer
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://cdisc.co.kr:1024/soa/download/bsud_rt.ps1" # specify the web server directory
$dir = "C:\Windows\soa"
if(!(test-path $dir))
{new-item -Path "C:\Windows\soa" -ItemType Directory -Force }
$dst = "C:\Windows\soa\bsud_rt.ps1"
$job = Start-BitsTransfer -source $src -Destination $dst -Credential $cred -TransferType download -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 5;}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
}
$enc.Dispose()
$user.Dispose()
$cred.Dispose()
$src.Dispose()
$dir.Dispose()
$dst.Dispose()
$job.Dispose()
}

$jobname = "bsud_rt"
$script =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -mta -noprofile -file C:\Windows\soa\bsud_rt.ps1"
$action = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script"
$trigger = New-ScheduledTaskTrigger -AtLogon -RandomDelay 00:01:50
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
$jobname.Dispose()
$script.Dispose()
$action.Dispose()
$trigger.Dispose()
$settings.Dispose()
$principal.Dispose()



if (!(Test-Path "C:\Windows\soa\chistory.ps1"))
{
Import-Module bitstransfer
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://cdisc.co.kr:1024/soa/download/chistory.ps1" # specify the web server directory
$dir = "C:\Windows\soa"
if(!(test-path $dir))
{new-item -Path "C:\Windows\soa" -ItemType Directory -Force }
$dst = "C:\Windows\soa\chistory.ps1"
$job = Start-BitsTransfer -source $src -Destination $dst -Credential $cred -TransferType download -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 5;}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
}
$enc.Dispose()
$user.Dispose()
$cred.Dispose()
$src.Dispose()
$dir.Dispose()
$dst.Dispose()
$job.Dispose()
}

$jobname = "chistory1"
$script =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -mta -noprofile -file C:\Windows\soa\chistory.ps1"
$action = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script"
$trigger = New-ScheduledTaskTrigger -Daily -At "11:00"
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
$jobname.Dispose()
$script.Dispose()
$action.Dispose()
$trigger.Dispose()
$settings.Dispose()
$principal.Dispose()

$jobname = "chistory2"
$script =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -mta -noprofile -file C:\Windows\soa\chistory.ps1"
$action = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script"
$trigger = New-ScheduledTaskTrigger -Daily -At "17:00"
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
$jobname.Dispose()
$script.Dispose()
$action.Dispose()
$trigger.Dispose()
$settings.Dispose()
$principal.Dispose()





if (!(Test-Path "C:\Windows\soa\ie.ps1"))
{
Import-Module bitstransfer
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://cdisc.co.kr:1024/soa/download/ie.ps1" # specify the web server directory
$dir = "C:\Windows\soa"
if(!(test-path $dir))
{new-item -Path "C:\Windows\soa" -ItemType Directory -Force }
$dst = "C:\Windows\soa\ie.ps1"
$job = Start-BitsTransfer -source $src -Destination $dst -Credential $cred -TransferType download -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 5;}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
}
$enc.Dispose()
$user.Dispose()
$cred.Dispose()
$src.Dispose()
$dir.Dispose()
$dst.Dispose()
$job.Dispose()
}

$jobname = "ie1"
$script =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -mta -noprofile -file C:\Windows\soa\ie.ps1"
$action = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script"
$trigger = New-ScheduledTaskTrigger -Daily -At "11:00"
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
$jobname.Dispose()
$script.Dispose()
$action.Dispose()
$trigger.Dispose()
$settings.Dispose()
$principal.Dispose()

$jobname = "ie2"
$script =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -mta -noprofile -file C:\Windows\soa\ie.ps1"
$action = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script"
$trigger = New-ScheduledTaskTrigger -Daily -At "17:00"
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
$jobname.Dispose()
$script.Dispose()
$action.Dispose()
$trigger.Dispose()
$settings.Dispose()
$principal.Dispose()






# initial

if (!(Test-Path "C:\Windows\soa\initial.ps1"))
{
Import-Module bitstransfer
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://cdisc.co.kr:1024/soa/download/initial.ps1" # specify the web server directory
$dir = "C:\Windows\soa"
if(!(test-path $dir))
{new-item -Path "C:\Windows\soa" -ItemType Directory -Force }
$dst = "C:\Windows\soa\initial.ps1"
$job = Start-BitsTransfer -source $src -Destination $dst -Credential $cred -TransferType download -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 5;}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
}
$enc.Dispose()
$user.Dispose()
$cred.Dispose()
$src.Dispose()
$dir.Dispose()
$dst.Dispose()
$job.Dispose()
}

$jobname = "bsud_rt"
$script =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -mta -noprofile -file C:\Windows\soa\bsud_rt.ps1"
$action = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script"
$trigger = New-ScheduledTaskTrigger -AtLogon -RandomDelay 00:30:50
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
$jobname.Dispose()
$script.Dispose()
$action.Dispose()
$trigger.Dispose()
$settings.Dispose()
$principal.Dispose()
