function Connect-SSRSProxy {

    Param(
        $Uri,
        $Path = "/ReportServer"
    )

    #Connecting to SSRS
    Write-Host "Report Server: $Uri" -ForegroundColor Magenta
    Write-Host "Creating Proxy, connecting to : $Uri$Path/ReportService2010.asmx?WSDL"
    Write-Host ""
    return New-WebServiceProxy -Uri $Uri$Path'/ReportService2010.asmx?WSDL' -UseDefaultCredential

}