param([string]$Username, [string]$passwd, [string]$ip, [string]$name)

$Pass = ''

if($passwd){
    $Pass = ConvertTo-SecureString $passwd -AsPlainText -Force
} else {
    $Pass = New-Object System.Security.SecureString
}

$Cred = New-Object System.Management.Automation.PSCredential -ArgumentList $Username,$Pass

$jobname = ('{0}_PROCESS' -f $name)

Invoke-Command -ComputerName $ip -Credential $Cred -AsJob -JobName $jobname -ScriptBlock {param($name) Get-Process -Name $name } -ArgumentList $name
