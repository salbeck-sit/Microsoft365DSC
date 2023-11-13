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
    -DscResource 'IntuneAccountProtectionLocalAdministratorPasswordSolutionPolicy' -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope

        BeforeAll {
            $secpasswd = ConvertTo-SecureString 'Pass@word1' -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Update-MgBetaDeviceManagementConfigurationPolicy -MockWith {
            }

            Mock -CommandName New-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                return @{
                    Id = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                }
            }

            Mock -CommandName Remove-MgBetaDeviceManagementConfigurationPolicy -MockWith {
            }

            Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicyTemplate -MockWith {
                return @{
                    TemplateId = 'adc46e5a-f4aa-4ff6-aeff-4f27bc525796_1'
                }
            }

            Mock -CommandName Get-DeviceManagementConfigurationPolicyAssignment -MockWith {
                return @(@{
                        dataType     = '#microsoft.graph.exclusionGroupAssignmentTarget'
                        collectionId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                    })
            }
            Mock -CommandName Update-DeviceConfigurationPolicyAssignment -MockWith {
            }
            Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicyTemplateSettingTemplate -MockWith {
                return @({
                    Id       = '1'
                    SettingDefinitions = @(
                        Id = 'device_vendor_msft_laps_policies_backupdirectory'
                    )
                    SettingInstanceTemplate = @{
                        settingDefinitionId = 'device_vendor_msft_laps_policies_backupdirectory'
                        settingInstanceTemplateId = 'a3270f64-e493-499d-8900-90290f61ed8a'
                        AdditionalProperties = @{
                            '@odata.type' = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstanceTemplate'
                        }
                    }
                })
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }

        }

        # Test contexts
        Context -Name "When the instance doesn't already exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = @(
                        (New-CimInstance -ClassName MSFT_IntuneAccountProtectionLocalAdministratorPasswordSolutionPolicyAssignments -Property @{
                            DataType     = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            CollectionId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                        } -ClientOnly)
                    )
                    Credential      = $Credential
                    Description     = 'My Test Description'
                    DisplayName     = 'My Test'
                    Ensure          = 'Present'
                    Identity        = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                    BackupDirectory = '1'
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                    return $null
                }
            }

            It 'Should return absent from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should create the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MgBetaDeviceManagementConfigurationPolicy' -Exactly 1
            }
        }

        Context -Name 'When the instance already exists and is NOT in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntuneAccountProtectionLocalAdministratorPasswordSolutionPolicyAssignments -Property @{
                            DataType     = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            CollectionId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                        } -ClientOnly)
                    )
                    Credential      = $Credential
                    Description     = 'My Test Description'
                    DisplayName     = 'My Test'
                    Ensure          = 'Present'
                    Identity        = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                    BackupDirectory = '0'
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        Id    = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                        Description = 'My Test Description'
                        Name        = 'My Test'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicySetting -MockWith {
                    return @{
                        Id                   = 0
                        SettingDefinitions   = $null
                        SettingInstance      = @{
                            SettingDefinitionId              = 'device_vendor_msft_laps_policies_backupdirectory'
                            SettingInstanceTemplateReference = @{
                                SettingInstanceTemplateId = 'a3270f64-e493-499d-8900-90290f61ed8a'
                            }
                            AdditionalProperties             = @{
                                '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                choiceSettingValue = @{
                                    children = @()
                                    value = "device_vendor_msft_laps_policies_backupdirectory_1"
                                }
                            }
                        }
                        AdditionalProperties = $null
                    }
                }
                Mock -CommandName Update-DeviceManagementConfigurationPolicy -MockWith {
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should update the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Update-DeviceManagementConfigurationPolicy -Exactly 1
            }
        }

        Context -Name 'When the instance already exists and IS in the Desired State' -Fixture {
            BeforeAll {
                $testParams = @{
                    Credential  = $Credential
                    Description = 'My Test Description'
                    DisplayName = 'My Test'
                    Ensure      = 'Present'
                    Identity    = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_IntuneAccountProtectionLocalAdministratorPasswordSolutionPolicyAssignments -Property @{
                            DataType     = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            CollectionId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                        } -ClientOnly)
                    )
                    BackupDirectory = '1'
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        Id    = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                        Description = 'My Test Description'
                        Name        = 'My Test'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicySetting -MockWith {
                    return @{
                        Id                   = 0
                        SettingDefinitions   = $null
                        SettingInstance      = @{
                            SettingDefinitionId              = 'device_vendor_msft_laps_policies_backupdirectory'
                            SettingInstanceTemplateReference = @{
                                SettingInstanceTemplateId = 'a3270f64-e493-499d-8900-90290f61ed8a'
                            }
                            AdditionalProperties             = @{
                                '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                choiceSettingValue = @{
                                    children = @()
                                    value = "device_vendor_msft_laps_policies_backupdirectory_1"
                                }
                            }
                        }
                        AdditionalProperties = $null
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'When the instance exists and it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    Assignments = @(
                        (New-CimInstance -ClassName MSFT_IntuneAccountProtectionLocalAdministratorPasswordSolutionPolicyAssignments -Property @{
                            DataType     = '#microsoft.graph.exclusionGroupAssignmentTarget'
                            CollectionId = '26d60dd1-fab6-47bf-8656-358194c1a49d'
                        } -ClientOnly)
                    )
                    Credential  = $Credential
                    Description = 'My Test Description'
                    DisplayName = 'My Test'
                    Ensure      = 'Absent'
                    Identity    = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        Id    = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                        Description = 'My Test Description'
                        Name        = 'My Test'
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicySetting -MockWith {
                    return @{
                        Id                   = 0
                        SettingDefinitions   = $null
                        SettingInstance      = @{
                            SettingDefinitionId              = 'device_vendor_msft_laps_policies_backupdirectory'
                            SettingInstanceTemplateReference = @{
                                SettingInstanceTemplateId = 'a3270f64-e493-499d-8900-90290f61ed8a'
                            }
                            AdditionalProperties             = @{
                                '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                choiceSettingValue = @{
                                    children = @()
                                    value = "device_vendor_msft_laps_policies_backupdirectory_1"
                                }
                            }
                        }
                        AdditionalProperties = $null
                    }
                }
            }

            It 'Should return Present from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should remove the instance from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-MgBetaDeviceManagementConfigurationPolicy -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicy -MockWith {
                    return @{
                        Id    = '619bd4a4-3b3b-4441-bd6f-3f4c0c444870'
                        Description = 'My Test Description'
                        Name        = 'My Test'
                        TemplateReference = @{
                            TemplateId = 'adc46e5a-f4aa-4ff6-aeff-4f27bc525796_1'
                        }
                    }
                }

                Mock -CommandName Get-MgBetaDeviceManagementConfigurationPolicySetting -MockWith {
                    return @{
                        Id                   = 0
                        SettingDefinitions   = $null
                        SettingInstance      = @{
                            SettingDefinitionId              = 'device_vendor_msft_laps_policies_backupdirectory'
                            SettingInstanceTemplateReference = @{
                                SettingInstanceTemplateId = 'a3270f64-e493-499d-8900-90290f61ed8a'
                            }
                            AdditionalProperties             = @{
                                '@odata.type'      = '#microsoft.graph.deviceManagementConfigurationChoiceSettingInstance'
                                choiceSettingValue = @{
                                    children = @()
                                    value = "device_vendor_msft_laps_policies_backupdirectory_1"
                                }
                            }
                        }
                        AdditionalProperties = $null
                    }
                }
            }

            It 'Should Reverse Engineer resource from the Export method' {
                $result = Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
