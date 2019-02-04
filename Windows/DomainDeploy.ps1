configuration BuildDomainController
{
    Import-DscResource -ModuleName xActiveDirectory, xComputerManagement, xNetworking, xDnsServer
    Node DC01
    {

        LocalConfigurationManager {
            ActionAfterReboot = 'ContinueConfiguration'
            ConfigurationMode = 'ApplyOnly'
            RebootNodeIfNeeded = $true
        }
 
        xIPAddress NewIPAddress {
            IPAddress = $node.IPAddress
            InterfaceAlias = $node.InterfaceAlias
            AddressFamily = 'IPV4'
        }

        xDefaultGatewayAddress NewIPGateway {
            Address = $node.GatewayAddress
            InterfaceAlias = $node.InterfaceAlias
            AddressFamily = 'IPV4'
            DependsOn = '[xIPAddress]NewIPAddress'
        }

        xDnsServerAddress PrimaryDNSClient {
            Address = $node.DnsAddress
            InterfaceAlias = $node.InterfaceAlias
            AddressFamily = 'IPV4'
            DependsOn = '[xDefaultGatewayAddress]NewIPGateway'
        }

        User Administrator {
            Ensure = 'Present'
            UserName = 'Administrator'
            Password = $Cred
            DependsOn = '[xDnsServerAddress]PrimaryDNSClient'
        }

        xComputer NewComputerName {
            Name = $node.ThisComputerName
            DependsOn = '[User]Administrator'
        }

        WindowsFeature ADDSInstall {
            Ensure = 'Present'
            Name = 'AD-Domain-Services'
            DependsOn = '[xComputer]NewComputerName'
        }

        xADDomain DC01 {
            DomainName = $node.DomainName
            DomainAdministratorCredential = $domainCred
            SafemodeAdministratorPassword = $domainCred
            DatabasePath = $node.DCDatabasePath
            LogPath = $node.DCLogPath
            SysvolPath = $node.SysvolPath
            DependsOn = '[WindowsFeature]ADDSInstall'
        }

        xADUser MePush {
            DomainName = $node.DomainName
            Path = "CN=Users,$($node.DomainDN)"
            UserName = 'MePush'
            GivenName = 'MePush'
            Surname = 'Technician'
            DisplayName = 'MePush Technician'
            Enabled = $true
            Password = $Cred
            DomainAdministratorCredential = $Cred
            PasswordNeverExpires = $true
            DependsOn = '[xADDomain]DC01'
        }

        xADGroup IT {
            GroupName = 'MEPUSH'
            Path = "CN=Users,$($node.DomainDN)"
            Category = 'Security'
            GroupScope = 'Global'
            MembersToInclude = 'mepush'
            DependsOn = '[xADDomain]DC01'
        }

        xADGroup DomainAdmins {
            GroupName = 'Domain Admins'
            Path = "CN=Users,$($node.DomainDN)"
            Category = 'Security'
            GroupScope = 'Global'
            MembersToInclude = 'gshields', 'myaccount'
            DependsOn = '[xADDomain]DC01'
        }

        xADGroup EnterpriseAdmins {
            GroupName = 'Enterprise Admins'
            Path = "CN=Users,$($node.DomainDN)"
            Category = 'Security'
            GroupScope = 'Universal'
            MembersToInclude = 'gshields', 'myaccount'
            DependsOn = '[xADDomain]DC01'
        }

        xADGroup SchemaAdmins {
            GroupName = 'Schema Admins'
            Path = "CN=Users,$($node.DomainDN)"
            Category = 'Security'
            GroupScope = 'Universal'
            MembersToInclude = 'gshields', 'myaccount'
            DependsOn = '[xADDomain]DC01'
        }

        xDnsServerADZone addReverseADZone {
            Name = '3.168.192.in-addr.arpa'
            DynamicUpdate = 'Secure'
            ReplicationScope = 'Forest'
            Ensure = 'Present'
            DependsOn = '[xADDomain]DC01'
        }
    }
}
            
$ConfigData = @{
    AllNodes = @(
        @{
            Nodename = "DC01"
            ThisComputerName = "DC01"
            IPAddress = "192.168.198.129/24"
            DnsAddress = "192.168.198.2"
            GatewayAddress = "192.168.198.2"
            InterfaceAlias = "Ethernet0"
            DomainName = "MePush.local"
            DomainDN = "DC=MePush,DC=local"
            DCDatabasePath = "C:\NTDS"
            DCLogPath = "C:\NTDS"
            SysvolPath = "C:\Sysvol"
            PSDscAllowPlainTextPassword = $true
            PSDscAllowDomainUser = $true
        }
    )
}

$domainCred = Get-Credential -UserName company\Administrator -Message "Please enter a new password for Domain Administrator."
$Cred = Get-Credential -UserName Administrator -Message "Please enter a new password for Local Administrator and other accounts."

BuildDomainController -ConfigurationData $ConfigData

Set-DSCLocalConfigurationManager -Path .\BuildDomainController –Verbose
Start-DscConfiguration -Wait -Force -Path .\BuildDomainController -Verbose