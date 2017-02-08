# Get Information of remote computer

# Set parameters for remote computer
param([string]$username, [string]$passwd, [string]$servername, [string]$path)

$pass = ''

if($passwd){
    # Set secure password
    $pass = ConvertTo-SecureString $passwd -AsPlainText -Force
    
} else {
    $pass=New-Object System.Security.SecureString
}

# Create credential to connect remote computer
$credential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList $username, $pass


# Create PowerShell session to connect remote computer
# $newsession = New-PSSession -ComputerName $servername -Credential $credential

# Get Manufacturer 
$manufacturer = Invoke-Command -ComputerName $servername -Credential $credential -ScriptBlock `
    {$computerSystem = get-wmiobject Win32_ComputerSystem; $computerSystem.manufacturer}


# Get state of remote computer
$isConnect = Test-Connection -ComputerName $servername -Count 1 -Quiet
# Get Model
$model = Invoke-Command -ComputerName $servername -Credential $credential -ScriptBlock `
    {$computerSystem = get-wmiobject Win32_ComputerSystem; $computerSystem.model}

# Get Serial Number
$serialnumber = Invoke-Command -ComputerName $servername -Credential $credential -ScriptBlock `
    {$computerBIOS = get-wmiobject Win32_BIOS; $computerBIOS.SerialNumber}

# Get RAM
$ram = Invoke-Command -ComputerName $servername -Credential $credential -ScriptBlock `
    {$computerSystem = get-wmiobject Win32_ComputerSystem; $computerSystem.TotalPhysicalMemory/1GB }

# Get OS
$osname = Invoke-Command -ComputerName $servername -Credential $credential -ScriptBlock `
    {$computerOS = get-wmiobject Win32_OperatingSystem; $computerOS.caption }

# Get CPU
$cpuname = Invoke-Command -ComputerName $servername -Credential $credential -ScriptBlock `
    {$computerCPU = get-wmiobject Win32_Processor; $computerCPU.Name }

$diskcapacity = Invoke-Command -ComputerName $servername -Credential $credential -ScriptBlock `
    {get-WmiObject win32_logicaldisk -Filter "DriveType='3'" | select Name, Size, FreeSpace}
# Get CPU Load
$AVGProc = Invoke-Command -ComputerName $servername -Credential $credential -ScriptBlock `
    { Get-WmiObject win32_processor | Measure-Object -property LoadPercentage -Average | Select Average }
# Get Ram Load
$OS = Invoke-Command -ComputerName $servername -Credential $credential -ScriptBlock `
    { gwmi -Class win32_operatingsystem | Select-Object @{Name = "MemoryUsage"; Expression = {“{0:N2}” -f ((($_.TotalVisibleMemorySize - $_.FreePhysicalMemory)*100)/ $_.TotalVisibleMemorySize) }} }

$object = New-Object -TypeName psobject 
$object | Add-Member -MemberType NoteProperty -Name State -Value $isConnect
$object | Add-Member -MemberType NoteProperty -Name Manufacturer -Value $manufacturer
$object | Add-Member -MemberType NoteProperty -Name Model -Value $model
$object | Add-Member -MemberType NoteProperty -Name SerialNumber -Value $serialnumber
$object | Add-Member -MemberType NoteProperty -Name Ram -Value $ram
$object | Add-Member -MemberType NoteProperty -Name MemLoad -Value $OS.MemoryUsage
$object | Add-Member -MemberType NoteProperty -Name Osname -Value $osname
$object | Add-Member -MemberType NoteProperty -Name CPUname -Value $cpuname
$object | Add-Member -MemberType NoteProperty -Name CPULoad -Value $AVGProc.Average

foreach ($item in $diskcapacity) {
    $totalsize_name = ('{0}_{1}' -f 'TotalSize',$item.Name)
    $freespace_name = ('{0}_{1}' -f 'FreeSpace',$item.Name)
    $object | Add-Member -MemberType NoteProperty -Name $totalsize_name -Value $item.Size
    $object | Add-Member -MemberType NoteProperty -Name $freespace_name -Value $item.FreeSpace
}

$result_file_path = ('{0}{1}' -f $path,'ComputerInfo.csv')
Write-Output $object | Export-Csv $result_file_path
