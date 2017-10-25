$cred = Get-Credential
$cred.password | ConvertFrom-SecureString | set-content C:\Windows\enp.txt