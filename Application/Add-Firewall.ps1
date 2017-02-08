Usernames = Import-CSV -Path

$Usernames |  foreach {
	$Pass=New-ObjectSystem.Security.SecureString
	$Cred=New-ObjectSystem.Management.Automation.PSCredential -ArgumentList $_.user,$Pass
	Invoke-Command -ComputerName $_.ip -Credential $Cred -ScriptBlock {&cmd.exe /c 'netsh advfirewall firewall add rule name="HTTP_80" protocol=TCP dir=in remoteip=any localport=80 action=allow'}
}
