#script to detect if computer might be infected by emotet malware

function Is-Numeric ($Value)
{
    return $Value -match "^[\d\.]+$"
}


$services = Get-Service

$infected = $false
foreach($service in $services){
    #$service
    $name = $service.Name
    $disname = $service.DisplayName
    if((Is-Numeric $name) -and (Is-Numeric $disname)){
        write-host "$name"
        $infected = $true
        #Set-Service $name -StartupType Disabled
        sc.exe delete $name 
    } 
}

write-host "infected: $infected"
if($infected){
    Write-host "check path"
    exit 1001
} else {
    exit 0
}


