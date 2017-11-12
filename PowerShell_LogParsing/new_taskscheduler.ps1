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
}
if($?)
{
$jobname = "reg"
$script =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -noprofile -file C:\Windows\soa\reg.ps1"
$action = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script"
$trigger = New-ScheduledTaskTrigger -AtLogOn -RandomDelay 00:00:30
$settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname -Action $action -Trigger $trigger -Principal $principal -Settings $settings -Force
}


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
}
if($?)
{
$jobname1 = "part"
$script1 =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -noprofile -file C:\Windows\soa\part.ps1"
$action1 = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script1"
$trigger1 = New-ScheduledTaskTrigger -AtLogOn -RandomDelay 00:00:35
$settings1 = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal1 = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname1 -Action $action1 -Trigger $trigger1 -Principal $principal1 -Settings $settings1 -Force
}



# oa_filteredlist


if (!(Test-Path "C:\Windows\soa\oa_filteredlist.ps1"))
{
Import-Module bitstransfer
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://cdisc.co.kr:1024/soa/download/oa_filteredlist.ps1" # specify the web server directory
$dir = "C:\Windows\soa"
if(!(test-path $dir))
{new-item -Path "C:\Windows\soa" -ItemType Directory -Force }
$dst = "C:\Windows\soa\oa_filteredlist.ps1"
$job = Start-BitsTransfer -source $src -Destination $dst -Credential $cred -TransferType download -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 5;}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
}
}
if($?)
{
$jobname2 = "oa_filteredlist"
$script2 =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -noprofile -file C:\Windows\soa\oa_filteredlist.ps1"
$action2 = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script2"
$trigger2 = New-ScheduledTaskTrigger -AtLogon -RandomDelay 00:01:00
$settings2 = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal2 = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname2 -Action $action2 -Trigger $trigger2 -Principal $principal2 -Settings $settings2 -Force
}



# logonoff / OA

if (!(Test-Path "C:\Windows\soa\sec_filtered.ps1"))
{
Import-Module bitstransfer
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://cdisc.co.kr:1024/soa/download/sec_filtered.ps1" # specify the web server directory
$dir = "C:\Windows\soa"
if(!(test-path $dir))
{new-item -Path "C:\Windows\soa" -ItemType Directory -Force }
$dst = "C:\Windows\soa\sec_filtered.ps1"
$job = Start-BitsTransfer -source $src -Destination $dst -Credential $cred -TransferType download -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 5;}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
}
}
if($?)
{
$jobname3 = "sec"
$script3 =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -noprofile -file C:\Windows\soa\sec_filtered.ps1"
$action3 = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script3"
$trigger3 = New-ScheduledTaskTrigger -AtLogon -RandomDelay 00:05:30
$settings3 = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal3 = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname3 -Action $action3 -Trigger $trigger3 -Principal $principal3 -Settings $settings3 -Force
}




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
}
if($?)
{
$jobname4 = "filezip1"
$script4 =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -noprofile -file C:\Windows\soa\filezip.ps1"
$action4 = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script4"
$trigger4 = New-ScheduledTaskTrigger -Daily -At "10:00"
$settings4 = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal4 = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname4 -Action $action4 -Trigger $trigger4 -Principal $principal4 -Settings $settings4 -Force

$jobname5 = "filezip2"
$script5 =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -noprofile -file C:\Windows\soa\filezip.ps1"
$action5 = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script5"
$trigger5 = New-ScheduledTaskTrigger -Daily -At "14:00"
$settings5 = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal5 = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname5 -Action $action5 -Trigger $trigger5 -Principal $principal5 -Settings $settings5 -Force
}



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
}
if($?)
{
$jobname6 = "dscan"
$script6 =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -noprofile -file C:\Windows\soa\dscan.ps1"
$action6 = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script6"
$trigger6 = New-ScheduledTaskTrigger -AtLogon
$settings6 = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal6 = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname6 -Action $action6 -Trigger $trigger6 -Principal $principal6 -Settings $settings6 -Force
}



# clipps

if (!(Test-Path "C:\Windows\soa\clips.ps1"))
{
Import-Module bitstransfer
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://cdisc.co.kr:1024/soa/download/clipps.ps1" # specify the web server directory
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
}
if($?)
{
$jobname7 = "clips"
$script7 =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -noprofile -file C:\Windows\soa\clips.ps1"
$action7 = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script7"
$trigger7 = New-ScheduledTaskTrigger -AtLogon
$settings7 = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal7 = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname7 -Action $action7 -Trigger $trigger7 -Principal $principal7 -Settings $settings7 -Force
}



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
}


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
}
if($?)
{
$jobname8 = "bsud_rt"
$script8 =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -noprofile -file C:\Windows\soa\bsud_rt.ps1"
$action8 = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script8"
$trigger8 = New-ScheduledTaskTrigger -AtLogon -RandomDelay 00:01:50
$settings8 = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal8 = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname8 -Action $action8 -Trigger $trigger8 -Principal $principal8 -Settings $settings8 -Force
}


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
}
if($?)
{
$jobname9 = "chistory1"
$script9 =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -noprofile -file C:\Windows\soa\chistory.ps1"
$action9 = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script9"
$trigger9 = New-ScheduledTaskTrigger -Daily -At "11:00"
$settings9 = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal9 = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname9 -Action $action9 -Trigger $trigger9 -Principal $principal9 -Settings $settings9 -Force

$jobname10 = "chistory2"
$script10 =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -noprofile -file C:\Windows\soa\chistory.ps1"
$action10 = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script10"
$trigger10 = New-ScheduledTaskTrigger -Daily -At "17:00"
$settings10 = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal10 = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname10 -Action $action10 -Trigger $trigger10 -Principal $principal10 -Settings $settings10 -Force
}




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
}
if($?)
{
$jobname11 = "ie1"
$script11 =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -noprofile -file C:\Windows\soa\ie.ps1"
$action11 = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script11"
$trigger11 = New-ScheduledTaskTrigger -Daily -At "11:00"
$settings11 = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal11 = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname11 -Action $action11 -Trigger $trigger11 -Principal $principal11 -Settings $settings11 -Force

$jobname12 = "ie2"
$script12 =  "-ExecutionPolicy Bypass -windowstyle hidden -noexit -noprofile -file C:\Windows\soa\ie.ps1"
$action12 = New-ScheduledTaskAction –Execute "powershell.exe" -Argument "$script12"
$trigger12 = New-ScheduledTaskTrigger -Daily -At "17:00"
$settings12 = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries -StartWhenAvailable -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)
$principal12 = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel "Highest"
Register-ScheduledTask -TaskName $jobname12 -Action $action12 -Trigger $trigger12 -Principal $principal12 -Settings $settings12 -Force
}