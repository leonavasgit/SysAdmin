# **************************************************************************************************************
#
# Script Name: Azure AD Creation Script.ps1
# Version: 1.0
# Author: Leonardo Navas
# Date: 1/24/2023
#
# Description: Script will try to facilitate the creation of Azure AD Users and Add them to the correct
#              Security Group, and Assign a License
#
#
# **************************************************************************************************************


# **************************************************************************************************************
#
# Step 1 -  You need to install Azure AD module on your computer if running for the first time
#
# **************************************************************************************************************

Install-Module -Name AzureAD
Get-Module AzureAD

# **************************************************************************************************************
#
# Step 2 -  You'll need to connect to the Azure AD Tenant where the user will be added
#
# **************************************************************************************************************

Connect-AzureAD
Get-AzureADUser

# **************************************************************************************************************
#
# Step 3 -  Modify the following variables based on the request
#
# **************************************************************************************************************

$Displayname = "Test Testington"
$UPN = "Test@stestington.com"
$MailNickName = "Test"
$Location = "US"

# **************************************************************************************************************
#
# Step 4 -  Set Password - Use Password.link to send the password "T3st1ngt0n1!"" to the customer
# https://password.link/
#
# **************************************************************************************************************

$pw = New-Object -Type Microsoft.Open.AzureAD.Model.PasswordProfile
$pw.password = "T3st1ngt0n1!"

# **************************************************************************************************************
#
# Step 5 -  Creation of Azure AD User
#
# **************************************************************************************************************

New-AzureADUser -AccountEnabled $true -PasswordProfile $pw -DisplayName $Displayname -UserPrincipalName $UPN `
 -MailNickName $MailNickName -UsageLocation $Location

# **************************************************************************************************************
#
# Step 6 -  Add newly created user to specified Azure AD Security Groups using their ObjectId
#
# **************************************************************************************************************

#Access to Sharepoint Example
Add-AzureADGroupMember -ObjectId "56dcbe16-375e-4f2b-a4d2-40fd3f9ef0b4" -RefObjectId (Get-AzureADUser -ObjectId $UPN).ObjectId

# **************************************************************************************************************
#
# Optional -  If User already exists and you need to add it to a security group uncomment
#
# **************************************************************************************************************

#Set User Location if already created
#$User = Get-AzureADUser -ObjectId $UPN
#Set-AzureADUser -ObjectId $UPN -UsageLocation "US"

# **************************************************************************************************************
#
# Step 7 -  Install Microsoft.Graph (Skip if already installed)
#
# **************************************************************************************************************

Step 1 Install the Module
Install-Module -Name Microsoft.Graph

# **************************************************************************************************************
#
# Step 8 -  Connect to Graph
#
# **************************************************************************************************************

Connect-Graph -Scopes "Organization.Read.All", "User.ReadWrite.All", "Application.ReadWrite.All"

# **************************************************************************************************************
#
# Step 9 -  View if we have available license, otherwise you need to buy
#
# **************************************************************************************************************

#View Windows 365 Available Licenses
$skuw365 = Get-MgSubscribedSku
$filteredSkus = $skuw365 | Where-Object {($_.SkuPartNumber -eq "CPC_E_2C_8GB_128GB​") -and ($_.ConsumedUnits -like "*")} | Select -Property Sku*, ConsumedUnits -ExpandProperty PrepaidUnits | Format-List
$filteredSkus

#View Microsoft 365 Premium Available Licenses
$skum365 = Get-MgSubscribedSku
$filteredSkus = $skum365 | Where-Object {($_.SkuPartNumber -eq "*SPB*") -and ($_.ConsumedUnits -like "*")} | Select -Property Sku*, ConsumedUnits -ExpandProperty PrepaidUnits | Format-List
$filteredSkus

# **************************************************************************************************************
#
# Step 10 -  Assign License if available or already purchased from Pax8
#
# **************************************************************************************************************

#Assign a Microsoft 365 Premium License
$SPB = Get-MgSubscribedSku -All | Where SkuPartNumber -eq 'SPB'
Set-MgUserLicense -UserId $UPN -AddLicenses @{SkuId = $SPB.SkuId} -RemoveLicenses @()

#Assign a Windows365 Cloud PC License
$W365 = Get-MgSubscribedSku -All | Where SkuPartNumber -eq 'CPC_E_2C_8GB_128GB​'
Set-MgUserLicense -UserId $UPN -AddLicenses @{SkuId = $W365.SkuId} -RemoveLicenses @()

Disconnect-Graph

# **************************************************************************************************************
#
# Step 11 -  Send information to requester
#
# **************************************************************************************************************

#Information to send to the client
Get-AzureADUser -ObjectId $UPN | Format-List -Property DisplayName, Mail, MailNickName

