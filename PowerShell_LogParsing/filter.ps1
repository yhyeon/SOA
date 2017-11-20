#$user = $env:USERNAME
#$path = "C:\Program Files", "C:\Program Files (x86)", "C:\ProgramData", "C:\Users\$user\IntelGraphicsProfiles", "C:\Windows"
$ErrorActionPreference = 'silentlycontinue'
if(!(test-path 'C:\ProgramData\soalog'))
{new-item -Path "C:\ProgramData\soalog" -ItemType Directory -Force }

if (!(test-path "C:₩ProgramData₩soalog₩path.txt"))
{
$dpath = "C:\"
(Get-ChildItem -Path $dpath -recurse -Directory | select Fullname).FullName | out-file C:\ProgramData\soalog\path.txt -Encoding utf8
(Get-ChildItem -Path $dpath -recurse -Directory -Hidden | select Fullname).FullName | out-file C:\ProgramData\soalog\path.txt -Encoding utf8 -Append
"C:\" | out-file C:\ProgramData\soalog\path.txt -Append

$fpath = "C:\ProgramData\soalog", "C:\Windows\soa", "C:\Users\$env:username\AppData\Local\Kakao", "C:\Program Files (x86)\Kakao\KakaoTalk"
(Get-ChildItem -Path $fpath -recurse -file | select Fullname).FullName | out-file C:\ProgramData\soalog\path.txt -Append -Encoding utf8
(Get-ChildItem -Path $fpath -recurse -file -Hidden | select Fullname).FullName | out-file C:\ProgramData\soalog\path.txt -Append -Encoding utf8
$dpath.Dispose()
$fpath.Dispose()
}
else
{
$compare = Get-Content -Path C:\ProgramData\soalog\path.txt
$dpath = "C:\"
(Get-ChildItem -Path $dpath -recurse -Directory | select Fullname).FullName | Where-Object {$_ -notin $compare} | out-file C:\ProgramData\soalog\path.txt -Append -Encoding utf8
(Get-ChildItem -Path $dpath -recurse -Directory -Hidden | select Fullname).FullName | out-file C:\ProgramData\soalog\path.txt -Encoding utf8
"C:\" | Where-Object {$_ -notin $compare} | out-file C:\ProgramData\soalog\path.txt -Append

$fpath = "C:\ProgramData\soalog", "C:\Windows\soa", "C:\Users\$env:username\AppData\Local\Kakao", "C:\Program Files (x86)\Kakao\KakaoTalk"
(Get-ChildItem -Path $fpath -recurse -file | select Fullname).FullName | Where-Object {$_ -notin $compare} | out-file C:\ProgramData\soalog\path.txt -Append -Encoding utf8
(Get-ChildItem -Path $fpath -recurse -file -Hidden | select Fullname).FullName | Where-Object {$_ -notin $compare} | out-file C:\ProgramData\soalog\path.txt -Append -Encoding utf8
$dpath.Dispose()
$fpath.Dispose()
}
