function Change-SSRSReportDataSources {

    Param(
        $Proxy,
        $Reports,
        $DataSourceName,
        $DataSourcePath
    )

    Write-Host "  Change Data Source $DataSourceName" -ForegroundColor Green
    Write-Host "    DataSourcePath = $DataSourcePath"

    foreach ($reportFullName in $Reports) {
        Write-Host "    Change Data Source for Report $reportFullName" -ForegroundColor Green
        $rep = $Proxy.GetItemDataSources($reportFullName)
        $rep | ForEach-Object {
            if ($_.Name -eq $DataSourceName) {
                $proxyNamespace = $_.GetType().Namespace
                $constDatasource = New-Object ("$proxyNamespace.DataSource")
                    $constDatasource.Item = New-Object ("$proxyNamespace.DataSourceReference")
                $constDatasource.Item.Reference = $DataSourcePath
                $_.item = $constDatasource.Item
                $Proxy.SetItemDataSources($reportFullName, $_)
                Write-Host "      Data Source Changed." -ForegroundColor Blue
            }
        }
    }

}