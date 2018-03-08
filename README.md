# Automate Server_Maint:
- Import-Module .\ServerMaint.psm1 

# What does it do so far:
- Get-p "localhost" = Ping test, is the computer online.
- Get-LoggedIn "localhost" = Shows you who is logged in on the desired machine.
- Get-Uptime "localhost" = Calculate and display system uptime on a local machine or remote machine.
- Get-HWVersion "localhost" = Retreives device name, driver date, and driver version
- Get-DellServiceTag = Display the Dell Service Tag of current computer
- Get-AdminServices = Pull services running with the account admin, administrator, etc.
- Get-ChangeAdminServices = Change the logged in admin password and the correlating services (needs checking with muliple services. Works fine with single service machines)
