[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
                        -ChildPath '..\..\Unit' `
                        -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
            -ChildPath '\Stubs\Microsoft365.psm1' `
            -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
    -ChildPath '\Stubs\Generic.psm1' `
    -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath '\UnitTestHelper.psm1' `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "IntuneDeviceConfigurationPlatformScriptWindows" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgBetaDeviceManagementScript -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementScript -MockWith {
            }

            Mock -CommandName Remove-MgBetaDeviceManagementScript -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false

            Mock -CommandName Get-MgBetaDeviceManagementScriptAssignment -MockWith {
            }

        }
        # Test contexts
        Context -Name "The IntuneDeviceConfigurationPlatformScriptWindows should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    EnforceSignatureCheck = $True
                    FileName = "FakeStringValue"
                    Id = "FakeStringValue"
                    RoleScopeTagIds = @("FakeStringValue")
                    RunAs32Bit = $True
                    RunAsAccount = "system"
                    ScriptContent = "AAAAAAA="
                    Ensure = "Present"
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementScript -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-MgBetaDeviceManagementScript -Exactly 1
            }
        }

        Context -Name "The IntuneDeviceConfigurationPlatformScriptWindows exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    EnforceSignatureCheck = $True
                    FileName = "FakeStringValue"
                    Id = "FakeStringValue"
                    RoleScopeTagIds = @("FakeStringValue")
                    RunAs32Bit = $True
                    RunAsAccount = "system"
                    ScriptContent = "AAAAAAA="
                    Ensure = 'Absent'
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementScript -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = "#microsoft.graph.DeviceManagementScript"
                        }
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        EnforceSignatureCheck = $True
                        FileName = "FakeStringValue"
                        Id = "FakeStringValue"
                        RoleScopeTagIds = @("FakeStringValue")
                        RunAs32Bit = $True
                        RunAsAccount = "system"
                        ScriptContent = [byte[]]::new(5)
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementScript -Exactly 1
            }
        }
        Context -Name "The IntuneDeviceConfigurationPlatformScriptWindows Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    EnforceSignatureCheck = $True
                    FileName = "FakeStringValue"
                    Id = "FakeStringValue"
                    RoleScopeTagIds = @("FakeStringValue")
                    RunAs32Bit = $True
                    RunAsAccount = "system"
                    ScriptContent = "AAAAAAA="
                    Ensure = 'Present'
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementScript -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = "#microsoft.graph.DeviceManagementScript"
                        }
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        EnforceSignatureCheck = $True
                        FileName = "FakeStringValue"
                        Id = "FakeStringValue"
                        RoleScopeTagIds = @("FakeStringValue")
                        RunAs32Bit = $True
                        RunAsAccount = "system"
                        ScriptContent = [byte[]]::new(5)
                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntuneDeviceConfigurationPlatformScriptWindows exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    EnforceSignatureCheck = $True
                    FileName = "FakeStringValue"
                    Id = "FakeStringValue"
                    RoleScopeTagIds = @("FakeStringValue")
                    RunAs32Bit = $True
                    RunAsAccount = "system"
                    ScriptContent = "AAAAAAA="
                    Ensure = 'Present'
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementScript -MockWith {
                    return @{
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        FileName = "FakeStringValue"
                        Id = "FakeStringValue"
                        RoleScopeTagIds = @("FakeStringValue")
                        RunAsAccount = "system"
                        ScriptContent = [byte[]]::new(5)
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-MgBetaDeviceManagementScript -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementScript -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = "#microsoft.graph.DeviceManagementScript"
                        }
                        CreatedDateTime = "2023-01-01T00:00:00.0000000+01:00"
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        EnforceSignatureCheck = $True
                        FileName = "FakeStringValue"
                        Id = "FakeStringValue"
                        LastModifiedDateTime = "2023-01-01T00:00:00.0000000+01:00"
                        RoleScopeTagIds = @("FakeStringValue")
                        RunAs32Bit = $True
                        RunAsAccount = "system"
                        ScriptContent = [byte[]]::new(5)
                    }
                }
            }
            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
                $result | Should -Not -BeNullOrEmpty
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
