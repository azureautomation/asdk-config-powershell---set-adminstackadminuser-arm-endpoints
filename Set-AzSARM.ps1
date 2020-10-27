<# 
.Synopsis 
Azure Stack ASDK! - Automate setup of AzureStackAdmin & AzureStackUser ARM Endpoints
 
.DESCRIPTION 
ASDK only! Sets PowerSHell Execution Policy, Import AzureStack 1.2.10 & AzureStack-Tools Modules, 
set AzureStackAdmin & AzureStackUser ARM Endpoints & add AzureRmAccounts, Register RPs, copy registration script 
to $PSHome and reset PowerShell Execution Policy back to default. To automate ARM setup each time you open PowerSHell, 
copy Install-AzSARM.ps1 to c:\temp (copy c:\scripts\Install-AzSARM.ps1 $PSHome -Force) and Put the command '.\Install-AzSARM.ps1' 
in your .Profile or type '.\Install-AzSARM.ps1' when open a new PowerShell session: .\Install-AzSARM.ps1 

.NOTES    
Name: Set-AzSARM 
Author: Gary Gallanes - GDog@Outlook.com
Version: 1.1 
DateCreated: 2017-07-16 
DateUpdated: 2017-07-16 
 
 
.PARAMETER None
No Parameters are used with this script
 
.EXAMPLE 
To automate ARM setup each time you open PowerSHell, copy Install-AzSARM.ps1 to $PSHome (copy c:\scripts\Install-AzSARM.ps1 $PSHome -Force)
Type '.\Install-AzSARM.ps1' after starting PowerShell session
.\Install-AzSARM.ps1 

.EXAMPLE
Add entry:'.\Install-AzSARM.ps1' to your .Profile 

#>
 
### Start - Set-AzSARM.ps1 #####################################################
$ResetExPol = Get-ExecutionPolicy
Set-ExecutionPolicy Unrestricted  -force

### Import AzureStack Modules 1.2.10 & Tools
Use-AzureRmProfile -Profile 2017-03-09-profile -Force
Import-Module -Name  AzureStack -RequiredVersion  1.2.10
cd c:\AzureStack-Tools-master
Import-Module .\Connect\AzureStack.Connect.psm1
Import-Module .\ComputeAdmin\AzureStack.ComputeAdmin.psm1
 
### Capture AAD Credentials
$AADUserName = read-host "Enter your Azure AD Global Admin Username: - EXAMPLE: GlobalAdmin@tenantid.onmicrosoft.com"
$ADPwd = read-host "Enter your Azure AD Global Admin Password"
$AADPassword = $ADPwd | ConvertTo-SecureString -Force  -AsPlainText
$AADCredential = New-Object PSCredential($AADUserName,$AADPassword)
$AADTenantID = ($AADUserName -split  '@')[1]
$Credential = $AADCredential
 
### Setup AzureStackAdmin ARM Endpoint
Add-AzureRMEnvironment -Name "AzureStackAdmin" -ArmEndpoint "https://adminmanagement.local.azurestack.external"

### Get TenantID GUID for Azure Stack
$TenantID = Get-AzsDirectoryTenantId -AADTenantName $AADTenantID -EnvironmentName AzureStackAdmin
 
### Login the AAD Admin into Admin ARM Env
Login-AzureRmAccount -EnvironmentName "AzureStackAdmin" -TenantId $TenantID -Credential $Credential
 
### Setup AzureStackUser ARM Endpoint and Login AzureRmAccount
Add-AzureRMEnvironment -Name "AzureStackUser" -ArmEndpoint "https://management.local.azurestack.external"
### Get TenantID GUID for AzureStackUser
$TenantID = Get-AzsDirectoryTenantId -AADTenantName $AADTenantID -EnvironmentName AzureStackUser
### Login the AAD Admin into AzureStackUser ARM Env
Login-AzureRmAccount -EnvironmentName "AzureStackUser" -TenantId $TenantID -Credential $Credential

### Get TenantID GUID for AzureStackAdmin
$TenantID = Get-AzsDirectoryTenantId -AADTenantName $AADTenantID -EnvironmentName AzureStackAdmin
### Login the AAD Admin into AzureStackAdmin ARM Env
Login-AzureRmAccount -EnvironmentName "AzureStackAdmin" -TenantId $TenantID -Credential $Credential

### Register Resource Providers
foreach($s in (Get-AzureRmSubscription)) {
        Select-AzureRmSubscription -SubscriptionId $s.SubscriptionId | Out-Null
        Write-Progress $($s.SubscriptionId + " : " + $s.SubscriptionName)
Get-AzureRmResourceProvider -ListAvailable | Register-AzureRmResourceProvider -Force
    } 
 
### Reset Execution Policy back to default
Set-ExecutionPolicy $ResetExPol -Force
 
