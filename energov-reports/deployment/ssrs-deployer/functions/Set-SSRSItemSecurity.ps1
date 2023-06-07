function Set-SSRSItemSecurity {

    Param(
        $Proxy,
        $ItemPath,
        $GroupOrUser,
        $Role = "Browser"
    )

    Write-Host "  Setting Item Security $ItemPath" -ForegroundColor Green
    Write-Host "    Group/User = $GroupOrUser"
    Write-Host "    Role = Browser"

    $roles = $Proxy.ListRoles("All", $null)

    $role = $roles | Where-Object { $_.Name -eq $Role }

    $type = $Proxy.GetType().Namespace
    $policyType = ($type + '.Policy');
    
    $inherit = $false

    $currentPolicies = $Proxy.GetPolicies($ItemPath, [ref] $inherit)

    $newPolicy = New-Object ($policyType)

    $newPolicy.GroupUserName = $GroupOrUser
    $newPolicy.Roles = $role

    $currentPolicies += $newPolicy

    $Proxy.SetPolicies($ItemPath, $currentPolicies)

}