. "$PSScriptRoot\library\library.ps1"

$scripts =  Get-ChildItem "$PSScriptRoot\functions" -Recurse -Include *.ps1
foreach ($script in $scripts) { . $script }