[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]
    $UnitTestFilePath
)

$moduleName = 'Pester'
$minVersion = '5.5.0'

$module = Get-Module -ListAvailable | Where-Object { $_.Name -eq $moduleName -and $_.Version -ge $minVersion }

if ($module -ne $null)
{
    Write-Output "Module $moduleName with version greater than or equal to $minVersion found."
}
else
{
    Write-Output "Module $moduleName with version greater than or equal to $minVersion not found."
    Write-Output 'Please install the module using the following command:'
    Write-Output "Install-Module -Name $moduleName -MinimumVersion $minVersion"
    return
}

if ($UnitTestFilePath.EndsWith('Tests.ps1'))
{
    $unitTest = Get-Item -Path $UnitTestFilePath
    $unitTestName = "$($unitTest.Name.Split('.')[1])"

    $coveragePath = (Join-Path -Path $PSScriptRoot `
            -ChildPath "..\Modules\Microsoft365DSC\DSCResources\MSFT_$($unitTestName)\MSFT_$($unitTestName).psm1" `
            -Resolve)

    $config = New-PesterConfiguration
    $config.Run.Path = $UnitTestFilePath
    $config.CodeCoverage.Enabled = $true
    $config.CodeCoverage.Path = $coveragePath
    Invoke-Pester -Configuration $config
}
