# -------------------------------------------
# Function Name: p
# Test if a computer is online (quick ping replacement)
# -------------------------------------------
function p {
    param($computername)
    return (test-connection $computername -count 1 -quiet)
}

# -------------------------------------------
# Function Name: Get-LoggedIn
# Return the current logged-in user of a remote machine.
# -------------------------------------------
function Get-LoggedIn {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory=$True)]
    [string[]]$computername
  )

  foreach ($pc in $computername){
    $logged_in = (gwmi win32_computersystem -COMPUTER $pc).username
    $name = $logged_in.split("\")[1]
    "{0}: {1}" -f $pc,$name
  }
}

# -------------------------------------------
# Function Name: Get-Uptime
# Calculate and display system uptime on a local machine or remote machine.
# TODO: Fix multiple computer name / convertdate errors when providing more
# than one computer name.
# -------------------------------------------
function Get-Uptime {
    [CmdletBinding()]
    param (
        [string]$ComputerName = 'localhost'
    )
    
    foreach ($Computer in $ComputerName){
        $pc = $computername
        $os = Get-WmiObject -Class Win32_OperatingSystem -ComputerName $computername
        $diff = $os.ConvertToDateTime($os.LocalDateTime) - $os.ConvertToDateTime($os.LastBootUpTime)

        $properties=@{
            'ComputerName'=$pc;
            'UptimeDays'=$diff.Days;
            'UptimeHours'=$diff.Hours;
            'UptimeMinutes'=$diff.Minutes
            'UptimeSeconds'=$diff.Seconds
        }
        $obj = New-Object -TypeName PSObject -Property $properties

        Write-Output $obj
    }
       
 }

# -------------------------------------------
# Function Name: Get-HWVersion
# Retreives device name, driver date, and driver version
# -------------------------------------------
function Get-HWVersion($computer, $name) {

     $pingresult = Get-WmiObject win32_pingstatus -f "address='$computer'"
     if($pingresult.statuscode -ne 0) { return }

     gwmi -Query "SELECT * FROM Win32_PnPSignedDriver WHERE DeviceName LIKE '%$name%'" -ComputerName $computer | 
           Sort DeviceName | 
           Select @{Name="Server";Expression={$_.__Server}}, DeviceName, @{Name="DriverDate";Expression={[System.Management.ManagementDateTimeconverter]::ToDateTime($_.DriverDate).ToString("MM/dd/yyyy")}}, DriverVersion
}
# -------------------------------------------
# Function Name: Get-DellServiceTag
# Retreives Dell Service Tag
# -------------------------------------------
function Get-DellServiceTag{
    Get-WmiObject win32 systemenclosure | select serialnumber
}
# -------------------------------------------
# Function Name: Get-AdminServices
# Retreives services that are using Administrator (Like Admin Accounts)
# -------------------------------------------
function Get-AdminServices{
    Get-WmiObject Win32_Service -filter 'STARTNAME LIKE"%Admin%"'
}
# -------------------------------------------
# Function Name: Get-ChangeAdminServices
# Retreives Rename the Admin Password and change all services for the account. 
# Admin Account = Currently logged in as admin. Please check services with Get-AdminServices
# -------------------------------------------
function Get-ChangeAdminServices{
    $in= Read-Host -Prompt 'Enter password to change for the This Account and its Attatched Services:'
    $sPass= ConvertTo-SecureString -String $in -AsPlainText -Force
    $me=whoami
    $name=$me.split("\")[1]
    Set-ADAccountPassword $name -NewPassword $sPass -Reset
    Set-ADUser $name -ChangePasswordAtLogon $false

    $Service= Get-WmiObject -Class Win32_Service -Filter 'STARTNAME LIKE "%admin%"'
    echo $Service | Select Name
    $Pass= Read-Host -Prompt "Enter Password again: " -AsSecureString
    $BSTR = [system.runtime.interopservices.marshal]::SecureStringToBSTR($Pass)
    $Pass = [system.runtime.interopservices.marshal]::PtrToStringAuto($BSTR)
    echo $Pass
    $Service.Change($Null,$Null,$Null,$Null,$Null,$Null,$Null,$Pass,$Null,$Null,$Null) 

    $Service.StopService().ReturnValue
    $Service.StartService().ReturnValue 
}