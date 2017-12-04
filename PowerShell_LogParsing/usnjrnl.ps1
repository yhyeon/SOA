$ErrorActionPreference = 'silentlycontinue'

Import-Module PowerForensics
$uj = (Get-ForensicUsnJrnl -VolumeName C:)
$ujs = $uj | select volumepath, recordnumber, filesequencenumber, parentfilerecordnumber, parentfilesequencenumber, usn, timestamp, reason, filename, fileattributes
$count = $uj.Count
for($i = 0; $i -lt $count; $i++)
{
$timestamp = $ujs[$i].timestamp | Get-Date -Format yyyy-MM-ddTHH:mm:ss+09:00
[string]($ujs[$i].VolumePath) + ":::;" + [string]($ujs[$i].RecordNumber)  + ":::;" + [string]($ujs[$i].FileSequenceNumber) + ":::;" + [string]($ujs[$i].ParentFileRecordNumber) + ":::;" + [string]($ujs[$i].ParentFileSequenceNumber) + ":::;" + [string]($ujs[$i].Usn) + ":::;" + $timestamp + ":::;" + [string]($ujs[$i].Reason) + ":::;" + [string]($ujs[$i].FileName) + ":::;" + [string]($ujs[$i].FileAttributes) | select -Unique | Out-File C:\ProgramData\soalog\${sn}_$(get-date -f yyyyMMddHHmmss)_usnjrnl.txt -Append -Encoding utf8
$i.Dispose()
}
$count.Dispose()
$ujs.Dispose()
$uj.Dispose()