Import-Module .\ssrs-deployer\SSRSDeployer.psm1 -Force

function DeployEnvironment {

    Param($Proxy, $ReportPath, $ReportFolder, `
        $DataSourceConnectString_EnerGov, $UserName_EnerGov, $Password_EnerGov, `
        $DataSourceConnectString_CSS, $UserName_CSS, $Password_CSS)

    Write-host ""
    Write-Host "Deploying SSRS Environment:" -ForegroundColor Magenta
    Write-Host "  ReportPath: $ReportPath"
    Write-Host "  ReportFolder: $ReportFolder"
    Write-Host "  DataSourceConnectString_EnerGov: $DataSourceConnectString_EnerGov"
    Write-Host "  DataSourceConnectString_CSS: $DataSourceConnectString_CSS"

    $reportFolder_Final = Create-SSRSFolder -Proxy $Proxy -Name $ReportFolder -Path $ReportPath

    $dataSourcePath_EnerGov = Create-SSRSDataSource -Proxy $Proxy -Name "EnerGov" -Prompt "EnerGov Login" -DataProvider "SQL" `
        -ConnectString $DataSourceConnectString_EnerGov -Overwrite -Path $reportFolder_Final `
        -CredentialRetrievalStore -UserName $UserName_EnerGov -Password $Password_EnerGov
    
    $dataSourcePath_CSS = Create-SSRSDataSource -Proxy $Proxy -Name "EnerGov CSS" -Prompt "EnerGov Login" -DataProvider "SQL" `
        -ConnectString $DataSourceConnectString_CSS -Overwrite -Path $reportFolder_Final `
        -CredentialRetrievalStore -UserName $UserName_CSS -Password $Password_CSS

    $reports = Upload-SSRSReports -Proxy $Proxy -Overwrite -Source "..\reports\" -Path $reportFolder_Final

    Change-SSRSReportDataSources -Proxy $Proxy -Reports $reports -DataSourceName "EnerGov" -DataSourcePath $dataSourcePath_EnerGov
    Change-SSRSReportDataSources -Proxy $Proxy -Reports $reports -DataSourceName "EnerGovCss" -DataSourcePath $dataSourcePath_CSS
    DeployUnInvoicedPermitFeesForUtilityCustomersLinkedReports -Proxy $Proxy -ReportFolder $reportFolder_Final
    
    foreach ($subDirectory in Get-ChildItem "..\reports\" -Directory) {
        write-host "Processing Folder $subDirectory" -ForegroundColor Green

        $subDirectory_ReportFolderPath = $ReportPath + "/" + $ReportFolder

        $subDirectoryReportFolder = Create-SSRSFolder -Proxy $Proxy -Name $subDirectory.Name -Path $subDirectory_ReportFolderPath
        $subDirectoryReports = Upload-SSRSReports -Proxy $Proxy -Overwrite -Source $subDirectory.FullName -Path $subDirectoryReportFolder

        Change-SSRSReportDataSources -Proxy $Proxy -Reports $subDirectoryReports -DataSourceName "EnerGov" -DataSourcePath $dataSourcePath_EnerGov
        Change-SSRSReportDataSources -Proxy $Proxy -Reports $subDirectoryReports -DataSourceName "EnerGovCss" -DataSourcePath $dataSourcePath_CSS

    }

    

    Write-host "  We have successfully Deployed the SSRS Environment" -ForegroundColor Magenta
    Write-host ""
}

function DeployUnInvoicedPermitFeesForUtilityCustomersLinkedReports {

    Param(
        $Proxy,
        $ReportFolder
    )

    $unInvoicedPermitFeesForUtilityCustomersReportFolder = Create-SSRSFolder -Proxy $Proxy -Name "Un Invoiced Utility Fees" -Path $ReportFolder

    Create-SSRSLinkedReport -Proxy $Proxy -Name "Stormwater Utility" -Path $unInvoicedPermitFeesForUtilityCustomersReportFolder -ReportPath $ReportFolder -Report "UnInvoiced Permit Fees By Customer" |
        LinkedReportParam -Name "GlobalEntityId" -DefaultValues @('94bf4f88-b6db-4270-a28e-25ed366c3fe6') -Prompt "Customer" |
        Set-SSRSLinkedReportParams
    
    Create-SSRSLinkedReport -Proxy $Proxy -Name "Wastewater Utility" -Path $unInvoicedPermitFeesForUtilityCustomersReportFolder -ReportPath $ReportFolder -Report "UnInvoiced Permit Fees By Customer" |
        LinkedReportParam -Name "GlobalEntityId" -DefaultValues @('ef635302-6a26-48dd-bc26-208f554f5910') -Prompt "Customer" |
        Set-SSRSLinkedReportParams
    
    Create-SSRSLinkedReport -Proxy $Proxy -Name "Water Utility" -Path $unInvoicedPermitFeesForUtilityCustomersReportFolder -ReportPath $ReportFolder -Report "UnInvoiced Permit Fees By Customer" |
        LinkedReportParam -Name "GlobalEntityId" -DefaultValues @('cf189bcd-3ead-42a0-bcaf-9f26a7cbeb30') -Prompt "Customer" |
        Set-SSRSLinkedReportParams

}

function DeployReportEnvironment {

    Param(
        $Path,
        $SSRSProxy
    )

    DeployEnvironment -Proxy $SSRSProxy -ReportPath $Path -ReportFolder "Prod" `
        -DataSourceConnectString_EnerGov "Data Source=lax-sql1\ENERGOV;Initial Catalog=energov_prod;" -UserName_EnerGov "app_EnerGovReports" -Password_EnerGov "" `
        -DataSourceConnectString_CSS "Data Source=lax-sql1\ENERGOV;Initial Catalog=energov_prod_CSS;" -UserName_CSS "app_EnerGovReports" -Password_CSS ""
    DeployEnvironment -Proxy $SSRSProxy -ReportPath $Path -ReportFolder "Test" `
        -DataSourceConnectString_EnerGov "Data Source=lax-sql1\ENERGOV;Initial Catalog=energov_test;" -UserName_EnerGov "app_EnerGovReports" -Password_EnerGov "" `
        -DataSourceConnectString_CSS "Data Source=lax-sql1\ENERGOV;Initial Catalog=energov_test_CSS;" -UserName_CSS "app_EnerGovReports" -Password_CSS ""
    DeployEnvironment -Proxy $SSRSProxy -ReportPath $Path -ReportFolder "Train" `
        -DataSourceConnectString_EnerGov "Data Source=lax-sql1\ENERGOV;Initial Catalog=energov_train;" -UserName_EnerGov "app_EnerGovReports" -Password_EnerGov "" `
        -DataSourceConnectString_CSS "Data Source=lax-sql1\ENERGOV;Initial Catalog=energov_train_CSS;" -UserName_CSS "app_EnerGovReports" -Password_CSS ""
}

function DeployReports {

    Param($Path)

    $oldSSRSProxy = Connect-SSRSProxy -Uri "https://lax-sql1.cityoflacrosse.org"
    DeployReportEnvironment -Path $Path -SSRSProxy $oldSSRSProxy
    
    # $newSSRSProxy = Connect-SSRSProxy -Uri "https://dashboard.cityoflacrosse.org" -Path "/PBIReportServer"
    # DeployReportEnvironment -Path $Path -SSRSProxy $newSSRSProxy

}
