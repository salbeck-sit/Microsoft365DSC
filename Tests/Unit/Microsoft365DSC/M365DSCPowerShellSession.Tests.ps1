BeforeAll {
    $Script:ModuleMgmtModule = Get-Module -Name 'M365DSCModuleMgmt' -All | Select-Object -First 1
    if ($null -eq $Script:ModuleMgmtModule)
    {
        $Script:ModuleMgmtModule = Import-Module "$PSScriptRoot/../../../Modules/Microsoft365DSC/Modules/M365DSCModuleMgmt.psm1" -DisableNameChecking -PassThru
    }
}

Describe 'M365DSCPowerShellSession' {
    It 'Registers no PnP resolver when PnP.PowerShell ships no Microsoft.Identity.Client' {
        { & $Script:ModuleMgmtModule { param($Base) Register-M365DSCPnPIdentityClientResolver -ModuleBase $Base } $TestDrive } | Should -Not -Throw
    }
}
