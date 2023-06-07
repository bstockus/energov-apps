function Upload-SSRSReports {

    Param(
        $Proxy,
        [switch]$Overwrite,
        $Source,
        $Path
    )

    $reports = @()
     foreach ($rdlfile in Get-ChildItem $Source -Filter *.rdl) {
        $reportName = [System.IO.Path]::GetFileNameWithoutExtension($rdlFile);
        write-host "  Upload Report $reportName" -ForegroundColor Green 
        try {
            #Get Report content in bytes
            Write-Host "    Getting file content of : $rdlFile"
            #$byteArray = Get-Content $rdlFile.FullName -encoding byte
            $byteArray = [System.IO.File]::ReadAllBytes($rdlFile.FullName)
            $msg = "    Total length: {0}" -f $byteArray.Length
            Write-Host $msg
            Write-Host "    Uploading to: $Path"
            $type = $Proxy.GetType().Namespace
            $datatype = ($type + '.Property')
            $DescProp = New-Object($datatype)
            $DescProp.Name = 'Description'
            $DescProp.Value = ''
            $HiddenProp = New-Object($datatype)
            $HiddenProp.Name = 'Hidden'
            $HiddenProp.Value = 'false'
            $Properties = @($DescProp, $HiddenProp)
            #Call Proxy to upload report
            $warnings = $null
            $Results = $Proxy.CreateCatalogItem("Report", $reportName, $Path, $Overwrite, $byteArray, $Properties, [ref]$warnings) 
            if ($warnings.length -le 1) {
                Write-Host "    Upload Success" -ForegroundColor Blue
            }
            else {
                write-host $warnings 
            } 
        }
        catch [System.IO.IOException] {
            $msg = "Error while reading rdl file : '{0}', Message: '{1}'" -f $rdlFile, $_.Exception.Message
            Write-Error msg
        }
        catch [System.Web.Services.Protocols.SoapException] {
          
            $msg = "Error uploading report: $reportName. Msg: '{0}'" -f $_.Exception.Detail.InnerText
            Write-Error $msg
          
        }
        $reports += $Path + "/" + $reportName
    }

    return $reports

}