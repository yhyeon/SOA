Import-Module bitstransfer
$regpath = Test-Path "C:\Windows\soa\registry.ps1"
if($regpath -like "False")
{
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://192.168.1.50/SOA/download/registry.ps1" # specify the web server directory
$dst = "C:\Windows\soa\registry.ps1"
$job = Start-BitsTransfer -source $src -Destination $dst -Credential $cred -TransferType download -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 5;}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
"Error" {$job | Format-List}
}
$taskname = "registry parsing"
$action = New-ScheduledTaskAction -execute "powershell.exe" -Argument '-File "C:\Windows\soa\Registry.ps1"'
$trigger = New-ScheduledTaskTrigger -Daily -At "16:00" # Specify the time
$settings = New-ScheduledTaskSettingsSet -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)

$principal = New-ScheduledTaskPrincipal -userID SYSTEM -LogonType ServiceAccount -RunLevel Highest
$definition = New-ScheduledTask -action $action -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask -TaskName $taskname -InputObject $definition
$task = Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue}
if($regpath -like "True")
{
$taskname = "registry parsing"
$action = New-ScheduledTaskAction -execute "powershell.exe" -Argument '-File "C:\Windows\soa\registry.ps1"'
$trigger = New-ScheduledTaskTrigger -Daily -At "16:00" # Specify the time
$settings = New-ScheduledTaskSettingsSet -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)

$principal = New-ScheduledTaskPrincipal -userID SYSTEM -LogonType ServiceAccount -RunLevel Highest
$definition = New-ScheduledTask -action $action -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask -TaskName $taskname -InputObject $definition
$task = Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue
}


$driverpath = Test-Path "C:\Windows\soa\partition_driver.ps1"
if($driverpath -like "False")
{
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://192.168.1.50/SOA/download/partition_driver.ps1" # specify the web server directory
$dst = "C:\Windows\soa\partition_driver.ps1"
$job = Start-BitsTransfer -source $src -Destination $dst -Credential $cred -TransferType download -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 5;}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
"Error" {$job | Format-List}
}
$taskname = "partition parsing"
$action = New-ScheduledTaskAction -execute "powershell.exe" -Argument '-File "C:\Windows\soa\partition_driver.ps1"'
$trigger = New-ScheduledTaskTrigger -Daily -At "16:00" # Specify the time
$settings = New-ScheduledTaskSettingsSet -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)

$principal = New-ScheduledTaskPrincipal -userID SYSTEM -LogonType ServiceAccount -RunLevel Highest
$definition = New-ScheduledTask -action $action -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask -TaskName $taskname -InputObject $definition
$task = Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue}
if($driverpath -like "True")
{
$taskname = "partition parsing"
$action = New-ScheduledTaskAction -execute "powershell.exe" -Argument '-File "C:\Windows\soa\partition_driver.ps1"'
$trigger = New-ScheduledTaskTrigger -Daily -At "16:00" # Specify the time
$settings = New-ScheduledTaskSettingsSet -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)

$principal = New-ScheduledTaskPrincipal -userID SYSTEM -LogonType ServiceAccount -RunLevel Highest
$definition = New-ScheduledTask -action $action -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask -TaskName $taskname -InputObject $definition
$task = Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue
}


$logonoffpath = Test-Path "C:\Windows\soa\logonoff.ps1"
if($logonoffpath -like "False")
{
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://192.168.1.50/SOA/download/logonoff.ps1" # specify the web server directory
$dst = "C:\Windows\soa\logonoff.ps1"
$job = Start-BitsTransfer -source $src -Destination $dst -Credential $cred -TransferType download -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 5;}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
"Error" {$job | Format-List}
}
$taskname = "logonoff parsing"
$action = New-ScheduledTaskAction -execute "powershell.exe" -Argument '-File "C:\Windows\soa\logonoff.ps1"'
$trigger = New-ScheduledTaskTrigger -Daily -At "16:00" # Specify the time
$settings = New-ScheduledTaskSettingsSet -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)

$principal = New-ScheduledTaskPrincipal -userID SYSTEM -LogonType ServiceAccount -RunLevel Highest
$definition = New-ScheduledTask -action $action -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask -TaskName $taskname -InputObject $definition
$task = Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue}
if($logonoffpath -like "True")
{
$taskname = "logonoff parsing"
$action = New-ScheduledTaskAction -execute "powershell.exe" -Argument '-File "C:\Windows\soa\logonoff.ps1"'
$trigger = New-ScheduledTaskTrigger -Daily -At "16:00" # Specify the time
$settings = New-ScheduledTaskSettingsSet -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)

$principal = New-ScheduledTaskPrincipal -userID SYSTEM -LogonType ServiceAccount -RunLevel Highest
$definition = New-ScheduledTask -action $action -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask -TaskName $taskname -InputObject $definition
$task = Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue
}


$iepath = Test-Path "C:\Windows\soa\IE.ps1"
if($iepath -like "False")
{
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://192.168.1.50/SOA/download/IE.ps1" # specify the web server directory
$dst = "C:\Windows\soa\IE.ps1"
$job = Start-BitsTransfer -source $src -Destination $dst -Credential $cred -TransferType download -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 5;}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
"Error" {$job | Format-List}
}
$taskname = "IE parsing"
$action = New-ScheduledTaskAction -execute "powershell.exe" -Argument '-File "C:\Windows\soa\IE.ps1"'
$trigger = New-ScheduledTaskTrigger -Daily -At "16:00" # Specify the time
$settings = New-ScheduledTaskSettingsSet -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)

$principal = New-ScheduledTaskPrincipal -userID SYSTEM -LogonType ServiceAccount -RunLevel Highest
$definition = New-ScheduledTask -action $action -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask -TaskName $taskname -InputObject $definition
$task = Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue}
if($iepath -like "True")
{
$taskname = "IE parsing"
$action = New-ScheduledTaskAction -execute "powershell.exe" -Argument '-File "C:\Windows\soa\IE.ps1"'
$trigger = New-ScheduledTaskTrigger -Daily -At "16:00" # Specify the time
$settings = New-ScheduledTaskSettingsSet -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)

$principal = New-ScheduledTaskPrincipal -userID SYSTEM -LogonType ServiceAccount -RunLevel Highest
$definition = New-ScheduledTask -action $action -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask -TaskName $taskname -InputObject $definition
$task = Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue
}


$oapath = Test-Path "C:\Windows\soa\oa_ft.ps1"
if($oapath -like "False")
{
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://192.168.1.50/SOA/download/oa_ft.ps1" # specify the web server directory
$dst = "C:\Windows\soa\oa_ft.ps1"
$job = Start-BitsTransfer -source $src -Destination $dst -Credential $cred -TransferType download -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 5;}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
"Error" {$job | Format-List}
}
$taskname = "oa_ft parsing"
$action = New-ScheduledTaskAction -execute "powershell.exe" -Argument '-File "C:\Windows\soa\oa_ft.ps1"'
$trigger = New-ScheduledTaskTrigger -Daily -At "16:00" # Specify the time
$settings = New-ScheduledTaskSettingsSet -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)

$principal = New-ScheduledTaskPrincipal -userID SYSTEM -LogonType ServiceAccount -RunLevel Highest
$definition = New-ScheduledTask -action $action -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask -TaskName $taskname -InputObject $definition
$task = Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue}
if($oapath -like "True")
{
$taskname = "oa_ft parsing"
$action = New-ScheduledTaskAction -execute "powershell.exe" -Argument '-File "C:\Windows\soa\oa_ft.ps1"'
$trigger = New-ScheduledTaskTrigger -Daily -At "16:00" # Specify the time
$settings = New-ScheduledTaskSettingsSet -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)

$principal = New-ScheduledTaskPrincipal -userID SYSTEM -LogonType ServiceAccount -RunLevel Highest
$definition = New-ScheduledTask -action $action -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask -TaskName $taskname -InputObject $definition
$task = Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue
}


$filefpath = Test-Path "C:\Windows\soa\file_f.ps1"
if($filefpath -like "False")
{
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://192.168.1.50/SOA/download/file_f.ps1" # specify the web server directory
$dst = "C:\Windows\soa\file_f.ps1"
$job = Start-BitsTransfer -source $src -Destination $dst -Credential $cred -TransferType download -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 5;}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
"Error" {$job | Format-List}
}
$taskname = "file_f parsing"
$action = New-ScheduledTaskAction -execute "powershell.exe" -Argument '-File "C:\Windows\soa\file_f.ps1"'
$trigger = New-ScheduledTaskTrigger -Daily -At "16:00" # Specify the time
$settings = New-ScheduledTaskSettingsSet -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)

$principal = New-ScheduledTaskPrincipal -userID SYSTEM -LogonType ServiceAccount -RunLevel Highest
$definition = New-ScheduledTask -action $action -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask -TaskName $taskname -InputObject $definition
$task = Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue}
if($filefpath -like "True")
{
$taskname = "file_f parsing"
$action = New-ScheduledTaskAction -execute "powershell.exe" -Argument '-File "C:\Windows\soa\file_f.ps1"'
$trigger = New-ScheduledTaskTrigger -Daily -At "16:00" # Specify the time
$settings = New-ScheduledTaskSettingsSet -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)

$principal = New-ScheduledTaskPrincipal -userID SYSTEM -LogonType ServiceAccount -RunLevel Highest
$definition = New-ScheduledTask -action $action -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask -TaskName $taskname -InputObject $definition
$task = Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue
}


$filenocpath = Test-Path "C:\Windows\soa\file_noc.ps1"
if($filenocpath -like "False")
{
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://192.168.1.50/SOA/download/file_noc.ps1" # specify the web server directory
$dst = "C:\Windows\soa\file_noc.ps1"
$job = Start-BitsTransfer -source $src -Destination $dst -Credential $cred -TransferType download -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 5;}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
"Error" {$job | Format-List}
}
$taskname = "file_noc parsing"
$action = New-ScheduledTaskAction -execute "powershell.exe" -Argument '-File "C:\Windows\soa\file_noc.ps1"'
$trigger = New-ScheduledTaskTrigger -Daily -At "16:00" # Specify the time
$settings = New-ScheduledTaskSettingsSet -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)

$principal = New-ScheduledTaskPrincipal -userID SYSTEM -LogonType ServiceAccount -RunLevel Highest
$definition = New-ScheduledTask -action $action -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask -TaskName $taskname -InputObject $definition
$task = Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue}
if($filenocpath -like "True")
{
$taskname = "file_noc parsing"
$action = New-ScheduledTaskAction -execute "powershell.exe" -Argument '-File "C:\Windows\soa\file_noc.ps1"'
$trigger = New-ScheduledTaskTrigger -Daily -At "16:00" # Specify the time
$settings = New-ScheduledTaskSettingsSet -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)

$principal = New-ScheduledTaskPrincipal -userID SYSTEM -LogonType ServiceAccount -RunLevel Highest
$definition = New-ScheduledTask -action $action -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask -TaskName $taskname -InputObject $definition
$task = Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue
}


$zipfpath = Test-Path "C:\Windows\soa\zip_f.ps1"
if($zipfpath -like "False")
{
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://192.168.1.50/SOA/download/zip_f.ps1" # specify the web server directory
$dst = "C:\Windows\soa\zip_f.ps1"
$job = Start-BitsTransfer -source $src -Destination $dst -Credential $cred -TransferType download -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 5;}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
"Error" {$job | Format-List}
}
$taskname = "zip_f parsing"
$action = New-ScheduledTaskAction -execute "powershell.exe" -Argument '-File "C:\Windows\soa\zip_f.ps1"'
$trigger = New-ScheduledTaskTrigger -Daily -At "16:00" # Specify the time
$settings = New-ScheduledTaskSettingsSet -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)

$principal = New-ScheduledTaskPrincipal -userID SYSTEM -LogonType ServiceAccount -RunLevel Highest
$definition = New-ScheduledTask -action $action -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask -TaskName $taskname -InputObject $definition
$task = Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue}
if($zipfpath -like "True")
{
$taskname = "zip_f parsing"
$action = New-ScheduledTaskAction -execute "powershell.exe" -Argument '-File "C:\Windows\soa\zip_f.ps1"'
$trigger = New-ScheduledTaskTrigger -Daily -At "16:00" # Specify the time
$settings = New-ScheduledTaskSettingsSet -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)

$principal = New-ScheduledTaskPrincipal -userID SYSTEM -LogonType ServiceAccount -RunLevel Highest
$definition = New-ScheduledTask -action $action -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask -TaskName $taskname -InputObject $definition
$task = Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue
}


$zipncpath = Test-Path "C:\Windows\soa\zip_noc.ps1"
if($zipncpath -like "False")
{
$enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
$user = "Administrator" # server ID
$cred = New-Object System.Management.Automation.PSCredential($user,$enc)
$src = "http://192.168.1.50/SOA/download/zip_noc.ps1" # specify the web server directory
$dst = "C:\Windows\soa\zip_noc.ps1"
$job = Start-BitsTransfer -source $src -Destination $dst -Credential $cred -TransferType download -Asynchronous
while (($job.jobstate -eq "Transferring") -or ($job.jobstate -eq "Connecting")) `
{sleep 5;}
Switch($job.jobstate)
{
"Transferred" {Complete-BitsTransfer -BitsJob $job}
"Error" {$job | Format-List}
}
$taskname = "zip_noc parsing"
$action = New-ScheduledTaskAction -execute "powershell.exe" -Argument '-File "C:\Windows\soa\zip_noc.ps1"'
$trigger = New-ScheduledTaskTrigger -Daily -At "16:00" # Specify the time
$settings = New-ScheduledTaskSettingsSet -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)

$principal = New-ScheduledTaskPrincipal -userID SYSTEM -LogonType ServiceAccount -RunLevel Highest
$definition = New-ScheduledTask -action $action -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask -TaskName $taskname -InputObject $definition
$task = Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue}
if($zipncpath -like "True")
{
$taskname = "zip_noc parsing"
$action = New-ScheduledTaskAction -execute "powershell.exe" -Argument '-File "C:\Windows\soa\zip_noc.ps1"'
$trigger = New-ScheduledTaskTrigger -Daily -At "16:00" # Specify the time
$settings = New-ScheduledTaskSettingsSet -DontStopOnIdleEnd -ExecutionTimeLimit ([TimeSpan]::Zero)

$principal = New-ScheduledTaskPrincipal -userID SYSTEM -LogonType ServiceAccount -RunLevel Highest
$definition = New-ScheduledTask -action $action -Principal $principal -Trigger $trigger -Settings $settings

Register-ScheduledTask -TaskName $taskname -InputObject $definition
$task = Get-ScheduledTask -TaskName $taskname -ErrorAction SilentlyContinue
}