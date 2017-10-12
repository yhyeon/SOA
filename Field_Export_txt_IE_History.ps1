function Get-History {            
[CmdletBinding()]            
param ()            

$env:hostIP = (Get-NetIPConfiguration | Where-Object { $_.IPv4DefaultGateway -ne $null -and $_.netadapter.status -ne "Disconnected"}).ipv4address.ipaddress 
$env:hostMAC = (Get-NetAdapter | where-object -FilterScript {$_.HardwareInterface -eq "True" -and $_.Status -ne "Disconnected"}).MacAddress 

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
               $datetime = "$($pageFolder.GetDetailsOf($_,2))"
               $split_date = $datetime.split(" ")      
               if($split_date[1] -eq "오후"){
                $time = $split_date[2].split(":")
                $add = [int]$time[0] + 12
                $Fin_Date = $split_date[0] + ":::;" + $add + ":" + $time[1]
               } elseif($split_date[1] -eq "오전")
               {
                    $split_date = $datetime.split(" ")
                    $time = $split_date[2].split(":")
                    $Fin_Date = $split_date[0] + ":::;" + $time[0] + ":" + $time[1]
               }

               $env:COMPUTERNAME + ":::;" + $env:username + ":::;"  + $($env:hostMAC) + ':::;' +  $($env:hostIP) + ':::;' +    
               $Fin_Date + ':::;' +
               $($site.Name).replace("내 PC", "") + ':::;' +$($pageFolder.GetDetailsOf($_,0)).replace("file:///", "") + ':::;' + $($pageFolder.GetDetailsOf($_,1))  | out-file C:\Users\Public\Documents\${env:COMPUTERNAME}_$(get-date -f yyyyMMddhhmm)_IEhistory.txt -Append
        }            
     }            
   }            
 }            
}     
}    