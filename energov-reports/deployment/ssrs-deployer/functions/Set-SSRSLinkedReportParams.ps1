
function Set-SSRSLinkedReportParams {

    Param(
        [Parameter(ValueFromPipeline=$true)]
        $LinkedReport
    )
    
    $results = $LinkedReport.Proxy.SetItemParameters($LinkedReport.LinkedReport, $LinkedReport.Params)

    Write-Host "    Parameters Set" -ForegroundColor Blue

}