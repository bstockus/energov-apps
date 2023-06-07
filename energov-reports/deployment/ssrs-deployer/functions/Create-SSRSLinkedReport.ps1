function Create-SSRSLinkedReport {

    Param(
        $Proxy,
        $Name,
        $Report,
        $Path,
        $ReportPath
    )

    Write-Host "  Create Linked Report $Name" -ForegroundColor Green
    Write-Host "    Report = $Path/$Report"

    $type = $Proxy.GetType().Namespace
    $linkPropertyType = ($type + '.Property')
    $linkProperty = New-Object ($linkPropertyType)
    $linkProperty.Name = "Description"
    $linkProperty.Value = ""

    $linkedReport = "$ReportPath/$Report"

    try {
        $results = $Proxy.CreateLinkedItem($Name, $Path, $linkedReport, $linkProperty)

        Write-Host "    Linked Report Created" -ForegroundColor Blue
    }
    catch [System.Web.Services.Protocols.SoapException] {
        # $msg = "Error creating Linked Report: $Name. Msg: '{0}'" -f $_.Exception.Detail.InnerText
        # Write-Error $msg

        if ($_.Exception.Detail.InnerText -match "[^rsItemAlreadyExists400]") {            
            Write-Host "    Linked Report already exists." -ForegroundColor Blue

        }
        else {
            $msg = "Error creating Linked Report: $Name. Msg: '{0}'" -f $_.Exception.Detail.InnerText
            Write-Error $msg
        }
    }

    return [PSCustomObject]@{
        Proxy = $Proxy
        LinkedReport = "$Path/$Name"
        Params = @()
    }

}