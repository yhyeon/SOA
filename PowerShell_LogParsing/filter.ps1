﻿#$user = $env:USERNAME
#$path = "C:\Program Files", "C:\Program Files (x86)", "C:\ProgramData", "C:\Users\$user\IntelGraphicsProfiles", "C:\Windows"
$ErrorActionPreference = 'silentlycontinue'
if(!(test-path 'C:\ProgramData\soalog'))
{new-item -Path "C:\ProgramData\soalog" -ItemType Directory -Force }

if (!(test-path "C:₩ProgramData₩soalog₩path.txt"))
{
$dpath = "C:\"
$dpathnohidden = (Get-ChildItem -Path $dpath -recurse -Directory | select Fullname).FullName
$dpathnohidden | out-file C:\ProgramData\soalog\path.txt -Encoding utf8 -Append
$dpathhidden = (Get-ChildItem -Path $dpath -recurse -Directory -Hidden | select Fullname).FullName
$dpathhidden | out-file C:\ProgramData\soalog\path.txt -Encoding utf8 -Append
"C:\" | out-file C:\ProgramData\soalog\path.txt -Append -Encoding utf8
#"C:\Users\Hyeon\AppData\Roaming\Microsoft\Windows\Libraries" | out-file C:\ProgramData\soalog\path.txt -Append -Encoding utf8
$dpathhn = (Get-ChildItem -Path $dpathhidden -Recurse -Directory | select Fullname).FullName
$dpathhn | out-file C:\ProgramData\soalog\path.txt -Encoding utf8 -Append

$fpath = "C:\ProgramData\soalog", "C:\Windows\soa", "C:\Users\$env:username\AppData\Local\Kakao", "C:\Program Files (x86)\Kakao\KakaoTalk", "C:\Users\$env:username\AppData\Local\Google\Chrome\User Data"
$fpathout = (Get-ChildItem -Path $fpath -recurse -file | select Fullname).FullName
$fpathout | out-file C:\ProgramData\soalog\path.txt -Append -Encoding utf8
$fpathhout = (Get-ChildItem -Path $fpath -recurse -file -Hidden | select Fullname).FullName
$fpathhout | out-file C:\ProgramData\soalog\path.txt -Append -Encoding utf8

$dpath.Dispose()
$dpathnohidden.Dispose()
$dpathhidden.Dispose()
$dpathhn.Dispose()
$fpathout.Dispose()
$fpathhout.Dispose()
$fpath.Dispose()

}

else
{
$compare = Get-Content -Path C:\ProgramData\soalog\path.txt
$dpath = "C:\"
$dpathnohidden = (Get-ChildItem -Path $dpath -recurse -Directory | select Fullname).FullName | Where-Object {$_ -notin $compare}
$dpathnohidden | out-file C:\ProgramData\soalog\path.txt -Append -Encoding utf8
$dpathhidden = (Get-ChildItem -Path $dpath -recurse -Directory -Hidden | select Fullname).FullName | Where-Object {$_ -notin $compare}
$dpathhidden | out-file C:\ProgramData\soalog\path.txt -Encoding utf8 -Append
"C:\" | Where-Object {$_ -notin $compare} | out-file C:\ProgramData\soalog\path.txt -Append Encoding utf8
#"C:\Users\Hyeon\AppData\Roaming\Microsoft\Windows\Libraries" | Where-Object {$_ -notin $compare} | out-file C:\ProgramData\soalog\path.txt -Append -Encoding utf8
$dpathhn = (Get-ChildItem -Path $dpathhidden -Recurse -Directory | select Fullname).FullName | Where-Object {$_ -notin $compare}
$dpathhn | out-file C:\ProgramData\soalog\path.txt -Encoding utf8 -Append


$fpath = "C:\ProgramData\soalog", "C:\Windows\soa", "C:\Users\$env:username\AppData\Local\Kakao", "C:\Program Files (x86)\Kakao\KakaoTalk", "C:\Users\$env:username\AppData\Local\Google\Chrome\User Data"
$fpathout = (Get-ChildItem -Path $fpath -recurse -file | select Fullname).FullName | Where-Object {$_ -notin $compare}
$fpathout | out-file C:\ProgramData\soalog\path.txt -Append -Encoding utf8
$fpathhout = (Get-ChildItem -Path $fpath -recurse -file -Hidden | select Fullname).FullName | Where-Object {$_ -notin $compare}
$fapthhout | out-file C:\ProgramData\soalog\path.txt -Append -Encoding utf8

$dpath.Dispose()
$dpathnohidden.Dispose()
$dpathhidden.Dispose()
$dpathhn.Dispose()
$fpathout.Dispose()
$fpathhout.Dispose()
$fpath.Dispose()
}
