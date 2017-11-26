$ErrorActionPreference = 'silentlycontinue'
if(!(test-path 'C:\ProgramData\soalog'))
{new-item -Path "C:\ProgramData\soalog" -ItemType Directory -Force }

    $env:hostIP = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.netadapter.status -ne "Disconnected"}).ipv4address.ipaddress 
    $env:hostMAC = (Get-NetAdapter | where-object -FilterScript {$_.HardwareInterface -eq "True" -and $_.Status -ne "Disconnected"} | Where-Object {$_.InterfaceDescription -notmatch "TEST"}).MacAddress 
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
    
    
    
    $shell = New-Object -ComObject Shell.Application       
    $history = $shell.NameSpace(34)  
    $folder = $history.Self       
    $history.Items() |          
        foreach {            
         if ($_.IsFolder) {   
           $siteFolder = $_.GetFolder        
           $siteFolder.Items() |       
           foreach {          
             $site = $_           
             if ($site.IsFolder) {   
                $pageFolder  = $site.GetFolder      
                $pageFolder.Items() |         
                foreach {           
                      if($($site.Name) -ne "내 PC")
                       {
                       $datetime = "$($pageFolder.GetDetailsOf($_,2))"   
                       $visit_time = Get-Date $datetime -Format yyyy-MM-ddTHH:mm:ss+09:00
                       $sn + ":::;" + $env:COMPUTERNAME + ":::;" + $env:username + ":::;"  + $env:hostIP + ':::;' + $env:hostMAC + ':::;'  +  $visit_time + ':::;' +
                       $($site.Name) + ':::;' +$($pageFolder.GetDetailsOf($_,0)) + ':::;' + $($pageFolder.GetDetailsOf($_,1)) + ':::;'  | out-file C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_IEhistory.txt -Append -encoding utf8

                       Start-Process -FilePath "C:\Windows\System32\rundll32.exe" -ArgumentList "InetCpl.cpl","ClearMyTracksByProcess 1" -NoNewWindow
                     $visit_time.Dispose()
                     $datetime.Dispose()
                     $site.Dispose()
                     $pageFolder.Dispose()
                     $siteFolder.Dispose()
                     
                       }
      $history.Dispose()
      $folder.Dispose()
      $shell.Dispose()
      $env:hostIP.Dispose()
      $env:hostMAC.Dispose()
      $sn.Dispose()

                       #$split_date = $datetime.split(" ")      
                       #if($split_date[1] -eq "오후"){
                        #$time = $split_date[2].split(":")
                        #$add = [int]$time[0] + 12
                        #$Fin_Date = $split_date[0] + ":::;" + $add + ":" + $time[1]
                       #} elseif($split_date[1] -eq "오전")
                       #{
                       #     $split_date = $datetime.split(" ")
                       #     $time = $split_date[2].split(":")
                        #    $Fin_Date = $split_date[0] + ":::;" + $time[0] + ":" + $time[1]
                       #}

                       #$test = $($pageFolder.GetDetailsOf($_,0)).replace("file:///", "")
                       #$last_access_time = (Get-ItemProperty -Path $test | select LastAccessTime).LastAccessTime
                       #$last_access_time = Get-Date -Format yyyy-MM-ddTHH:mm:ss+09:00
               
                }            
             }            
           }       
    
         }            
    }  
  

        Import-Module bitstransfer
        $enc = Get-Content C:\Windows\soa\enp.txt | ConvertTo-SecureString # specify the directory where the encrypted password file is located
        $user = "Administrator" # server ID
        $cred = New-Object System.Management.Automation.PSCredential($user,$enc)
        $src = "C:\ProgramData\soalog\*_IEhistory.txt"
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
$dst.Dispose()
$job.Dispose()
        }
        $enc.Dispose()
        $user.Dispose()
        $cred.Dispose()
        $src.Dispose()
    