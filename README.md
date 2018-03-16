# ServerMaint.psm1 (Automate Server_Maint)
- Import-Module .\ServerMaint.psm1 

# What does it do so far:
- Get-p "localhost" = Ping test, is the computer online.
- Get-LoggedIn "localhost" = Shows you who is logged in on the desired machine.
- Get-Uptime "localhost" = Calculate and display system uptime on a local machine or remote machine.
- Get-HWVersion "localhost" = Retreives device name, driver date, and driver version
- Get-DellServiceTag = Display the Dell Service Tag of current computer
- Get-AdminServices = Pull services running with the account admin, administrator, etc.
- Get-ChangeAdminServices = Change the logged in admin password and the correlating services (needs checking with muliple services. Works fine with single service machines)

# DomainPrep.psi (Prep a server to be a Domain Controller)
- Installs Modules for ActiveDirectory, CompputerMgmt, Networking, Dns

# DomainDeploy.ps1 (Deploy a Domain Controller)  
Deploys the server. User will need to change values(Inprocess for parameters):
-            Nodename = "DC01"
-            ThisComputerName = "DC01"
-            IPAddress = "192.168.198.129/24"
-            DnsAddress = "192.168.198.2"
-            GatewayAddress = "192.168.198.2"
-            InterfaceAlias = "Ethernet0"
-            DomainName = "MePush.local"
-            DomainDN = "DC=MePush,DC=local"
-            DCDatabasePath = "C:\NTDS"
-            DCLogPath = "C:\NTDS"
-            SysvolPath = "C:\Sysvol"
-            PSDscAllowPlainTextPassword = $true
-            PSDscAllowDomainUser = $true

Change to what you need... 

#Kill Emotet (Based on Tyler's Emotet Detection that deletes services)
Set-Executionpolicy unrestricted
.\kill_emotet.ps1


