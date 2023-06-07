$contents_path = "E:\WebApps\EnerGovApps\"
$app_pool_name = "EnerGovApps"
$website_name = "EnerGovApps"
$binding_host = "energov-apps.cityoflacrosse.org"
$certificate_thumbprint = "9EA4B221017E25C5C9947E2BC3874151407DC198"
$keepalive_url = "https://energov-apps.cityoflacrosse.org/__keepalive"

If (Get-Website | Where-Object { $_.Name -eq $website_name }) {
    Write-Host "Removing Website: $website_name"
    Remove-Website $website_name
}

If (Test-Path -Path "IIS:\AppPools\$app_pool_name") {
    Write-Host "Removing App Pool: $app_pool_name"
    Remove-WebAppPool $app_pool_name
}



if (!(Test-Path -PathType container -Path $contents_path)) {
    Write-Host "Creating Contents Folder: $contents_path"
    New-Item -ItemType Directory -Path $contents_path
}

Write-Host "Clearing Contents Folder: $contents_path"
Remove-Item $contents_path\* -Recurse -Force

Write-Host "Copying Items into Contents Folder"
Copy-Item -Path .\out\* -Destination $contents_path -Recurse -Force



Write-Host "Creating App Pool: $app_pool_name"
$app_pool = New-WebAppPool -Name $app_pool_name

Write-Host "  managedRuntimeVersion = ''"
$app_pool.managedRuntimeVersion = ""

Write-Host "  processModel.identityType = 'ApplicationPoolIdentity'"
$app_pool.processModel.identityType = "ApplicationPoolIdentity"

#Set-ItemProperty -Path "IIS:\AppPools\$app_pool_name" -Name "managedRuntimeVersion" -Value ""

Write-Host "Creating Website: $website_name"
Write-Host "  PhysicalPath: $contents_path"
Write-Host "  ApplicationPool: $app_pool_name"
Write-Host "  HostHeader: $binding_host"
$website = New-Website -Name $website_name -PhysicalPath $contents_path -ApplicationPool $app_pool_name -HostHeader $binding_host

Write-Host "  Creating SSL Binding:"
New-WebBinding -Name $website_name -IPAddress "*" -Port 443 -HostHeader $binding_host -Protocol "https"
Write-Host "    Certificate: $certificate_thumbprint"
(Get-WebBinding -Name $website_name -IPAddress "*" -Port 443).AddSslCertificate($certificate_thumbprint, "my")

# Write-Host "  Enabling Windows Authentication:"
# Set-WebConfigurationProperty -Filter '/system.webServer/security/authentication/windowsAuthentication' -Name 'enabled' -Value 'true' -PSPath 'IIS:\' -Location "$website_name/"


# Create Keep Alive Task
$scheduled_task_name = "KeepAliveScript_$website_name"
If (Get-ScheduledTask | Where-Object { $_.TaskName -eq $scheduled_task_name }) {
    Write-Host "Removing Scheduled Task: $scheduled_task_name"
    Unregister-ScheduledTask -TaskName $scheduled_task_name -Confirm:$false
}

$action = New-ScheduledTaskAction -Execute 'Powershell.exe' `
            -Argument $('-NoProfile -WindowStyle Hidden -command "& {Invoke-WebRequest ' + $keepalive_url + '}"')

$trigger = New-ScheduledTaskTrigger -Once -At 1am -RepetitionDuration  (New-TimeSpan -Days 1000)  -RepetitionInterval  (New-TimeSpan -Minutes 15)

Register-ScheduledTask -Action $action -Trigger $trigger -TaskName $scheduled_task_name -Description "Keep Alive Script - Issues HTTP request every 15 mins: $keepalive_url" -User "NT AUTHORITY\SYSTEM"