param([string]$Username, [string]$passwd, [string]$ip, [string]$url='example', [string]$uploadfile)

$Pass = ''

$user_upload = 'sev_user'
$pass_upload = 'abc13579'

if($passwd){
    $Pass = ConvertTo-SecureString $passwd -AsPlainText -Force
} else {
    $Pass = New-Object System.Security.SecureString
}

$Cred = New-Object System.Management.Automation.PSCredential -ArgumentList $Username,$Pass

Invoke-Command -ComputerName $ip -Credential $Cred -ScriptBlock {param($url,$uploadfile,$user_upload,$pass_upload)`
 $webclient = New-Object System.Net.WebClient;`
 $webclient.Credentials = New-Object System.Net.NetworkCredential($user_upload,$pass_upload);`
 $webclient.UploadFile($url,$uploadfile)} -ArgumentList $url, $uploadfile,$user_upload,$pass_upload
