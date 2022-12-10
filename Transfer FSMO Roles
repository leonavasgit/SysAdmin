# **************************************************************************************************************
#
# Script Name: Transfer FSMO Roles.ps1
# Version: 1.0
# Author: Leonardo Navas
# Date: 12/10/2022
#
# Description: Script will try to facilitate the transfer of FSMO Roles by using a friendly interactive menu
#              Keep in mind your AD Account or account you use must be Schema Admin in order to Transfer the
#              SchemaMaster Role
#
# **************************************************************************************************************


#---------------------------------------------------------------------------------------------
Write-Host ***********************************************************************************
Write-Host 
Write-Host 
Write-Host 'This is an interactive Script to Transfer FSMO Roles to Destination DC'
Write-Host 'Keep in mind you need to be Schema Admin in order to transfer SchemaMaster Role'
Write-Host
Write-Host 
Write-Host ***********************************************************************************
#---------------------------------------------------------------------------------------------

$DestinationDC= Read-Host "Please Provide the Destination Domain Controller"


function Show-Menu
{
    param (
        [string]$Title = 'Select a FSMO Roles'
    )
    Clear-Host
    Write-Host "======================= $Title ======================="
    Write-Host
    Write-Host "1: Press '1' To Transfer DomainNamingMaster Role."
    Write-Host "2: Press '2' To Transfer PDCEmulator Role."
    Write-Host "3: Press '3' To Transfer RIDMaster Role."
    Write-Host "4: Press '4' To Transfer SchemaMaster Role."
    Write-Host "5: Press '5' To Transfer InfrastructureMaster Role."
    Write-Host "6: Press '6' To Transfer All FSMO Roles."
    Write-Host "Q: Press 'Q' to quit."
}

Show-Menu –Title 'Select a FSMO Roles'
$Selection = Read-Host "Please make a selection"

if ($Selection -gt 6)
{
Write-host "Choose correct option" -ForegroundColor Cyan
}

#This will transfer DomainNamingMaster role to destination server

if ($Selection -eq 1)
{

 Move-ADDirectoryServerOperationMasterRole -OperationMasterRole DomainNamingMaster -Identity $destinationDc -confirm:$false

 Write-host "$result is transferred successfully to $destinationDc" -ForegroundColor DarkGreen -BackgroundColor Cyan

 netdom query fsmo |Select-String "Domain Naming Master"
}

#This will transfer PDCEmulator role to destination server

 if ($Selection -eq 2)
{

 Move-ADDirectoryServerOperationMasterRole -OperationMasterRole PDCEmulator -Identity $destinationDc -confirm:$false

 Write-host "FSMO Role(s) were transferred successfully to $destinationDc" -ForegroundColor DarkGreen -BackgroundColor Cyan

 netdom query fsmo |Select-String "PDC"
}

#This will transfer RID pool manager role to destination server

 if ($Selection -eq 3)
{

 Move-ADDirectoryServerOperationMasterRole -OperationMasterRole RIDMaster -Identity $destinationDc -confirm:$false

 Write-host "FSMO Role(s) were transferred successfully to $destinationDc" -ForegroundColor DarkGreen -BackgroundColor Cyan

 netdom query fsmo |Select-String "RID pool manager"
}

#This will transfer Schema Master role to destination server

 if ($Selection -eq 4)
{

 Move-ADDirectoryServerOperationMasterRole -OperationMasterRole SchemaMaster -Identity $destinationDc -confirm:$false

 Write-host "FSMO Role(s) were transferred successfully to $destinationDc" -ForegroundColor DarkGreen -BackgroundColor Cyan

 netdom query fsmo |Select-String "Schema Master"
}

#This will transfer Infrastructure Master role to destination server

 if ($Selection -eq 5)
{

 Move-ADDirectoryServerOperationMasterRole -OperationMasterRole InfrastructureMaster -Identity $destinationDc -confirm:$false

 Write-host "FSMO Role(s) were transferred successfully to $destinationDc" -ForegroundColor DarkGreen -BackgroundColor Cyan

 netdom query fsmo |Select-String "Infrastructure Master"
}

#This will transfer All roles to destination server

 if ($Selection -eq 6)
{

 Move-ADDirectoryServerOperationMasterRole -OperationMasterRole DomainNamingMaster,PDCEmulator,RIDMaster,SchemaMaster,InfrastructureMaster -Identity $destinationDc  -confirm:$false

 Write-host "FSMO Role(s) were transferred successfully to $destinationDc" -ForegroundColor DarkGreen -BackgroundColor Cyan

 netdom query fsmo
}

