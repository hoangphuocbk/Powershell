param([string]$Username, [string]$passwd, [string]$ip, [string]$path, [string]$schedule, [string]$modifier, [string]$startdate`
    ,[string]$starttime, [string]$enddate, [string]$taskname, [string]$taskrun, [string]$day, [string]$month, [string]$duration)

$Pass = ''

if($passwd){
    # Set secure password
    $Pass = ConvertTo-SecureString $passwd -AsPlainText -Force
    
} else {
    $Pass = New-Object System.Security.SecureString
}

# Create credential to connect remote computer
$Cred = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $Username, $Pass


$Command = ('schtasks.exe /create /f /sc {0} /tn {1} /tr {2}' -f $schedule, $taskname, $taskrun)

if($modifier){
    $Command = ('{0} /mo {1}' -f $Command, $modifier)
}
if($startdate){
    $Command = ('{0} /sd {1}' -f $Command, $startdate)
}
if($starttime){
    $Command = ('{0} /st {1}' -f $Command, $starttime)
}
if($day){
    $Command = ('{0} /d {1}' -f $Command, $day)
}
if($month){
    $Command = ('{0} /m {1}' -f $Command, $month)
}
if($enddate){
    $Command = ('{0} /ed {1}' -f $Command, $enddate)
}
if($duration){
    $Command = ('{0} /du {1}' -f $Command, $duration)
}

# Write-Host $Command


$Result = Invoke-Command -ComputerName $ip -Credential $Cred -ScriptBlock {param($Command) & cmd.exe /c $Command} -ArgumentList $Command 

$result_file_path = ('{0}\{1}' -f $path,'ResultAddTask.csv')
Write-Output $Result | Export-Csv $result_file_path
