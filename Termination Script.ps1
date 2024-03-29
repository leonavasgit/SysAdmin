# **************************************************************************************************************
#
# Script Name: Termination.ps1
# Version: 1.0
# Author: Leonardo Navas
# Date: 1/26/2023
#
# Description: Script will try to facilitate the termination process by doing the following:
#              Disable User, Sign out from all devices, remove all licenses, and convert mailbox to shared mailbox
#
#              If you get any error reach out to Leo Navas
#
#
# **************************************************************************************************************


# **************************************************************************************************************
#
# Step 1 -  You need to install Azure AD module on your computer if running for the first time
#
# **************************************************************************************************************

Install-Module -Name AzureAD

# **************************************************************************************************************
#
# Step 2 -  You'll need to connect to the Azure AD Tenant where you'll be working
#
# **************************************************************************************************************

Connect-AzureAD

# **************************************************************************************************************
#
# Step 3 -  Modify the UPN
#
# **************************************************************************************************************

$UPN = "TestingTon@Test.com"

# **************************************************************************************************************
#
# Step 4 -  Disable User Account, and Revoke all sessions
#
# **************************************************************************************************************

Set-AzureADUser -ObjectId $UPN -AccountEnabled $false
Revoke-AzureADUserAllRefreshToken -ObjectId $UPN
#Get-AzureADUserRegisteredDevice -ObjectId $UPN | Set-AzureADDevice -AccountEnabled $false

# **************************************************************************************************************
#
# Step 5 -  Remove all Licenses assigned to the user
#
# **************************************************************************************************************

Connect-Graph -Scopes "Organization.Read.All", "User.ReadWrite.All", "Application.ReadWrite.All"

$User = Get-MgUser -UserId $UPN
$SKUs = @(Get-MgUserLicenseDetail -UserId $User.id)

foreach ($SKU in $SKUs){
Set-MgUserLicense -UserId $User.id -AddLicenses @() -RemoveLicenses $Sku.SkuId -ErrorAction Stop}

Disconnect-Graph

# **************************************************************************************************************
#
# Step 6 -  Convert Mailbox to Shared Mailbox
#
# **************************************************************************************************************

Install-Module ExchangeOnlineManagement
Connect-ExchangeOnline

Set-Mailbox -Identity $UPN -Type Shared
Get-Mailbox -Identity $UPN | Format-List RecipientTypeDetails

Disconnect-ExchangeOnline
