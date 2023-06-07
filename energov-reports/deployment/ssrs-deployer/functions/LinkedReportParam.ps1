function LinkedReportParam {

    Param(
        [Parameter(ValueFromPipeline=$true)]
        $LinkedReport,
        $Name,
        [switch]$PromptUser,
        $DefaultValues,
        $Prompt
    )

    $type = $LinkedReport.Proxy.GetType().Namespace
    $itemParameterType = ($type + '.ItemParameter')
    $itemParameter = New-Object ($itemParameterType)
    $itemParameter.Name = $Name
    $itemParameter.Prompt = $Prompt
    $itemParameter.PromptUser = $PromptUser
    $itemParameter.PromptUserSpecified = $true
    $itemParameter.DefaultValues = $DefaultValues
    $itemParameter.DefaultValuesQueryBased = $false
    $itemParameter.DefaultValuesQueryBasedSpecified = $true
    
    Write-Host "    Setting Parameter $Name"

    $LinkedReport.Params += $itemParameter

    return $LinkedReport

}
