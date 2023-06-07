function Create-SSRSDataSource {

    Param(
        $Proxy,
        $Name,
        $Prompt,
        $DataProvider,
        $ConnectString,
        [switch]$Overwrite,
        $Path,
        [switch]$CredentialRetrievalPrompt,
        [switch]$CredentialRetrievalStore,
        $Password,
        $UserName
    )

    Write-Host "  Create Data Source $Name" -ForegroundColor Green
    Write-Host "    Connection = $DataProvider $ConnectString"

    try {
        $type = $Proxy.GetType().Namespace
        $datatype = ($type + '.DataSourceDefinition')
        $datatype_Prop = ($type + '.Property')
        $DescProp = New-Object($datatype_Prop)
        $DescProp.Name = 'Description'
        $DescProp.Value = ''
        $HiddenProp = New-Object($datatype_Prop)
        $HiddenProp.Name = 'Hidden'
        $HiddenProp.Value = 'false'
        $Properties = @($DescProp, $HiddenProp)
        $Definition = New-Object ($datatype)
        $Definition.Extension = $DataProvider
        $Definition.ConnectString = $ConnectString
        $Definition.Prompt = $Prompt
        if ($CredentialRetrievalPrompt) {
            $Definition.CredentialRetrieval = 'Prompt'
        } elseif ($CredentialRetrievalStore) {
            $Definition.CredentialRetrieval = 'Store'
            $Definition.UserName = $UserName
            $Definition.Password = $Password
        }
        
        $result = $Proxy.CreateDataSource($Name, $Path , $Overwrite, $Definition, $Properties)
        Write-Host "    Data Source Created" -ForegroundColor Blue
    }
    catch [System.Web.Services.Protocols.SoapException] {
        if ($_.Exception.Detail.InnerText -match "[^rsItemAlreadyExists400]") {
            Write-Host "    Data Source Already Exists" -ForegroundColor Blue
        }
        else {
          
            $msg = "Error uploading report: $rdsf. Msg: '{0}'" -f $_.Exception.Detail.InnerText
            Write-Error $msg
        }
    }

    return $Path + '/' + $Name

}