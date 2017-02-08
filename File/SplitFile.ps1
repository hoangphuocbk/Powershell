param([string]$file_path, [int16]$maptask)

$reader = New-Object System.IO.StreamReader($file_path)

$file_size = (Get-ChildItem -Path $file_path).Length

$chunk = $file_size / $maptask
$chunk +=1

$file_path_container = Split-Path -Path $path

$root_name = Split-Path -Path $path -Leaf -Resolve
$count = 1

$file_name = "{0}\{1}-{2}.csv" -f ($file_path_container, $root_name, $count)


while(($line = $reader.ReadLine()) -ne $null)
{
    Add-Content -Path $file_name -Value $line
    if((Get-ChildItem -path $fileName).Length -ge $chunk*$count){
        ++$count
        $file_name = "{0}\{1}-{2}.csv" -f ($file_path_container, $root_name, $count)
    }
}

$reader.Close()
