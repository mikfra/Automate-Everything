Get-PackageSource -Name PSGallery | Set-PackageSource -Trusted -Force -ForceBootstrap

Install-PackageProvider -Name NuGet -MinimumVersion 2.8.5.201 -Force

Install-Module xActiveDirectory -Force 
Install-Module xComputerManagement -Force 
Install-Module xNetworking -Force 
Install-Module xDnsServer -Force 