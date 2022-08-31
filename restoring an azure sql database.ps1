# ######## EXTRACT VARIABLES ########
# $ServerInstance = 'bi-vm-prod-ent'
# $DatabaseName = 'prestaging'
# $username = 'biadmin'
# $password = 'GreenBayonet999!'


# ######## IMPORT VARIABLES ########

# $targetServer = 'bi-prod-databases.database.windows.net'
# $targetDB = 'pre-staging'
# $usernameT = 'biadmin'
# $passwordT = 'IronBoot500!'
# $errorCount = 0


# ######## CLEAN VARIABLES ########
# $BackupFilePathRestore = "c:/bi_backup/tlrduphsg_live_Full*"

# ######## DROP VARIABLES ########
# $BackupFilePathBacpac = "c:/bi_backup/yardi_live.bacpac"



$username = Get-AutomationVariable -Name 'bi-finance-vm-username'
$password = Get-AutomationVariable -Name 'bi-finance-vm-password'
$DatabaseName = Get-AutomationVariable -Name  'bi-finance-db-prestaging'
$ServerInstance = Get-AutomationVariable -Name 'bi-finance-db-server-instance'


#CLEAN
$BackupFilePathBacpac = "c:\bi_backup\yardi_live.bacpac"
$BackupFilePathRestore = "c:/bi_backup/tlrduphsg_live_Full*"


#TARGET FOR EXTRACT
$usernameT = Get-AutomationVariable -Name 'bi-finance-db-target-username'
$passwordT = Get-AutomationVariable -Name 'bi-finance-db-target-password'
$targetServer = Get-AutomationVariable -Name 'bi-finance-db-server'
$targetDB = Get-AutomationVariable -Name 'bi-finance-db-extract'

#ERROR
$errorCount = 0



####### 05 EXTRACT #######
# extract the bacpac file from the Restored database

if($errorCount -eq 0){
    try{
# Get SQL Server Version 
    $SQLKey = Get-ItemProperty "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Microsoft SQL Server\Instance Names\SQL" 
    $SQLVersionNum = [regex]::Match($SQLKey.MSSQLSERVER, "\d\d").Value 
 
# Construct SqlPackage Path 
    $ToolPath = "C:\Program Files (x86)\Microsoft SQL Server\150\DAC\bin" 
    $OldPath = Get-Location 
    Set-Location $ToolPath 
 
# Run SqlPackage tool to export bacpac file 
    .\SqlPackage.exe /a:Export /ssn:$ServerInstance /sdn:$DatabaseName /tf:"C:\bi_backup\yardi_live.bacpac" /su:$username /sp:$password
    }
    catch {
        throw
        $errorCount = $errorCount +1
    }
}

"Extract" + $errorCount

####### 06 IMPORT  #######
# Import the bacpac to pre-staging environment
# If not run from master and not a clean environment this will fail
# TODO run the sweep on error at the top of the script to reset the environment ahead of a run

if($errorCount -eq 0){
    try{
# Construct SqlPackage Path 
    $ToolPath = "C:\Program Files (x86)\Microsoft SQL Server\150\DAC\bin" 
    $OldPath = Get-Location 
    Set-Location $ToolPath 

# Import the bacpac file to SQL
   .\sqlpackage.exe /a:Import /sf:"C:\bi_backup\yardi_live.bacpac" /tsn:$targetServer /tdn:$targetDB /tu:$usernameT /tp:$passwordT
    }
    catch{
        throw
        $errorCount = $errorCount + 1
    }
}

"Import" + $errorCount

###### 07 CLEAN #######
###### Clean up the files held on the VM
###### ignore errors as will occur if files not present - will not be terminating errors
###### todo: add logic to check if exists before trying to delete - test on VM before replacing

#6 Delete the bacpac file
if(!(Test-Path $BackupFilePathRestore))
{
    Write-Warning "$BackupFilePathRestore doesn't exist in the location"
    }else{
   Remove-Item -path $BackupFilePathRestore -recurse
}

#10 Drop the Staging environment
if(!(Test-Path $BackupFilePathBacpac))
{
    Write-Warning "$BackupFilePathBacpac doesn't exist in the location"
    }else{
   Remove-Item -path $BackupFilePathBacpac -recurse
   }
####### 08 TRIGGER THE TRANSFORM OR SWEEP ON ERROR #######

    if($errorCount -eq 0){
        # Transform
           $response =  Invoke-RestMethod -Uri "https://s2events.azure-automation.net/webhooks?token=nJ5Dt8GCKkmKyauP0Semh%2fWJGZM4Ex2lyNsm8H2jegU%3d" -Method POST
            Write-Output $response       
          "triggered transform" 
    } else {
        # Sweep
           $request = 'https://s2events.azure-automation.net/webhooks?token=WsxdRec16wZEILSGY9%2bVVe9A%2fE7lHXoj%2fxgA736r7Ro%3d'
            $result = Invoke-RestMethod -Method Post -Uri $request 
            Write-Output $result
            "triggered sweep" 
    }
    
$errorcount


