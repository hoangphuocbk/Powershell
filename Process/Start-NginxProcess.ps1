param([string]$Username, [string]$passwd, [string]$ip)

$Pass = ''

if($passwd){
    $Pass = ConvertTo-SecureString $passwd -AsPlainText -Force
} else {
    $Pass = New-Object System.Security.SecureString
}

$Cred = New-Object System.Management.Automation.PSCredential -ArgumentList $Username,$Pass

$cmd = 'cd C:\S-MMAS_Lotus\nginx && nginx.exe'

Invoke-Command -ComputerName $ip -Credential $Cred -AsJob -JobName START_NGINX -ScriptBlock {param($cmd) & cmd.exe /c $cmd } -ArgumentList $cmd
