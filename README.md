ASDK: Config PowerShell &amp; set AdminStackAdmin/User ARM Endpoints
====================================================================

            

 

For Azure AD Enabled Azure Stack TP3 only! ADFS COMING SOON. Sets PowerSHell Execution Policy, Import AzureStack 1.2.9 & AzureStack-Tools Modules,  
set AzureStackAdmin & AzureStackUser ARM Endpoints & add AzureRmAccounts, Register RPs, copy registration script  
to $PSHome and reset PowerShell Execution Policy back to default. To automate ARM setup each time you open PowerSHell,  
copy Install-AzSARM.ps1 to $PSHome (copy c:\scripts\Install-AzSARM.ps1 $PSHome -Force) and Put the command '.\Install-AzSARM.ps1'  
in your .Profile or type '.\Install-AzSARM.ps1' when open a new PowerShell session: .\Install-AzSARM.ps1  
** *** *

        
    
TechNet gallery is retiring! This script was migrated from TechNet script center to GitHub by Microsoft Azure Automation product group. All the Script Center fields like Rating, RatingCount and DownloadCount have been carried over to Github as-is for the migrated scripts only. Note : The Script Center fields will not be applicable for the new repositories created in Github & hence those fields will not show up for new Github repositories.
