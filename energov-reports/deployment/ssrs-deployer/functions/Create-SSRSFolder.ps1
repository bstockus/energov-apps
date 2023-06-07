function Create-SSRSFolder {

    Param($Proxy, $Name, $Path)

    $reportFolder_Final = $Path + "/" + $Name

    Write-Host "  Create Folder $reportFolder_Final" -ForegroundColor Green

    try {
        $results = $Proxy.DeleteItem($reportFolder_Final)
    }
    catch [System.Web.Services.Protocols.SoapException] {
        if ($_.Exception.Detail.InnerText -match "[^rsItemAlreadyExists400]") {
        }
        else {
            $msg = "Error creating folder: $Name. Msg: '{0}'" -f $_.Exception.Detail.InnerText
            Write-Error $msg
        }
    }

    try {
        $results = $Proxy.CreateFolder($Name, $Path, $null)
        Write-Host "    Created new folder" -ForegroundColor Blue
    }
    catch [System.Web.Services.Protocols.SoapException] {
        if ($_.Exception.Detail.InnerText -match "[^rsItemAlreadyExists400]") {
            Write-Host "    Folder already exists." -ForegroundColor Blue
        }
        else {
            $msg = "Error creating folder: $Name. Msg: '{0}'" -f $_.Exception.Detail.InnerText
            Write-Error $msg
        }
    }

    return $reportFolder_Final

}