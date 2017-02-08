param([string]$Username, [string]$passwd, [string]$ip, [string]$folder='', [string]$filename)

$Pass = ''

if($passwd){
    $Pass = ConvertTo-SecureString $passwd -AsPlainText -Force
} else {
    $Pass = New-Object System.Security.SecureString
}

$Cred = New-Object System.Management.Automation.PSCredential -ArgumentList $Username,$Pass

$command = ('del {0}\{1}' -f $folder,$filename)

Invoke-Command -ComputerName $ip -Credential $Cred -ScriptBlock {param($command) & cmd.exe /c $command } -ArgumentList $command
