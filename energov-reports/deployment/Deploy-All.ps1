$s = Get-PSSession -Name WinPSCompatSession
if ($null -eq $s) {
    $s = New-PSSession -Name WinPSCompatSession -UseWindowsPowerShell
}
Invoke-Command -Session $s -ScriptBlock {
    param ($rootDirectory)

    Set-Location $rootDirectory

    $scripts =  Get-ChildItem "$rootDirectory\deployment-scripts" -Recurse -Include *.ps1
    foreach ($script in $scripts) { . $script }
    
    DeployReports -Path "/EnerGov/Development"
    DeployReports -Path "/EnerGov/Staging"
    DeployReports -Path "/EnerGov/Production"
} -ArgumentList $PSScriptRoot