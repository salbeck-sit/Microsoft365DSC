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
    -DscResource "IntunePolicySets" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString "f@kepassword1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgbetaDeviceAppManagementPolicySet -MockWith {
            }

            Mock -CommandName New-MgbetaDeviceAppManagementPolicySet -MockWith {
            }

            Mock -CommandName Remove-MgbetaDeviceAppManagementPolicySet -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }

            Mock -CommandName Get-MgBetaDeviceAppManagementPolicySetAssignment -MockWith {
            }

        }
        # Test contexts
        Context -Name "The IntunePolicySets should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    GuidedDeploymentTags = @("FakeStringValue")
                    Id = "FakeStringValue"
                    RoleScopeTags = @("FakeStringValue")
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            dataType                                   = '#microsoft.graph.GroupAssignmentTarget'
                            groupId                                    = '12345678-1234-1234-1234-1234567890ab'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                        } -ClientOnly)
                    )
                    Items = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyItems -Property @{
                            dataType                                   = '#microsoft.graph.managedAppProtectionPolicySetItem'
                            payloadId                                    = 'T_12345678-1234-1234-1234-1234567890ab'
                            itemType = '#microsoft.graph.androidManagedAppProtection'
                            displayName = 'FakeStringValue'
                            guidedDeploymentTags = [string[]]@('FakeStringValue')
                        } -ClientOnly)
                    )
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgbetaDeviceAppManagementPolicySet -MockWith {
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
                Should -Invoke -CommandName New-MgbetaDeviceAppManagementPolicySet -Exactly 1
            }
        }

        Context -Name "The IntunePolicySets exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    GuidedDeploymentTags = @("FakeStringValue")
                    Id = "FakeStringValue"
                    RoleScopeTags = @("FakeStringValue")
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            dataType                                   = '#microsoft.graph.GroupAssignmentTarget'
                            groupId                                    = '12345678-1234-1234-1234-1234567890ab'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                        } -ClientOnly)
                    )
                    Items = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyItems -Property @{
                            dataType                                   = '#microsoft.graph.managedAppProtectionPolicySetItem'
                            payloadId                                    = 'T_12345678-1234-1234-1234-1234567890ab'
                            itemType = '#microsoft.graph.androidManagedAppProtection'
                            displayName = 'FakeStringValue'
                            guidedDeploymentTags = [string[]]@('FakeStringValue')
                        } -ClientOnly)
                    )
                    Ensure = 'Absent'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgbetaDeviceAppManagementPolicySet -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = "#microsoft.graph.PolicySet"
                        }
                        CreatedDateTime = "2023-01-01T00:00:00.0000000+00:00"
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        ErrorCode = "noError"
                        GuidedDeploymentTags = @("FakeStringValue")
                        Id = "FakeStringValue"
                        LastModifiedDateTime = "2023-01-01T00:00:00.0000000+00:00"
                        RoleScopeTags = @("FakeStringValue")
                        Status = "unknown"
                        Assignments = @(
                            [pscustomobject]@{
                                            Target = [pscustomobject]@{
                                                        AdditionalProperties = [pscustomobject]@{
                                                                                '@odata.type' = '#microsoft.graph.GroupAssignmentTarget'
                                                                                groupId = '12345678-1234-1234-1234-1234567890ab'
                                                                                }
                                                        DeviceAndAppManagementAssignmentFilterType = 'none'
                                                        DeviceAndAppManagementAssignmentFilterId = $null

                                                    }
                                            }
                                        )
                        Items = @(
                            [pscustomobject]@{

                                            AdditionalProperties = [pscustomobject]@{
                                                                    '@odata.type' = '#microsoft.graph.managedAppProtectionPolicySetItem'
                                                                    }
                                            payloadId = 'T_12345678-1234-1234-1234-1234567890ab'
                                            itemType = '#microsoft.graph.androidManagedAppProtection'
                                            displayName = 'FakeStringValue'
                                            guidedDeploymentTags = @('FakeStringValue')

                                            }
                                        )
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
                Should -Invoke -CommandName Remove-MgbetaDeviceAppManagementPolicySet -Exactly 1
            }
        }
        Context -Name "The IntunePolicySets Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description = "FakeStringValue"
                    DisplayName = "FakeStringValue"
                    GuidedDeploymentTags = @("FakeStringValue")
                    Id = "FakeStringValue"
                    RoleScopeTags = @("FakeStringValue")
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            dataType                                   = '#microsoft.graph.GroupAssignmentTarget'
                            groupId                                    = '12345678-1234-1234-1234-1234567890ab'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                        } -ClientOnly)
                    )
                    Items = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyItems -Property @{
                            dataType                                   = '#microsoft.graph.managedAppProtectionPolicySetItem'
                            payloadId                                    = 'T_12345678-1234-1234-1234-1234567890ab'
                            itemType = '#microsoft.graph.androidManagedAppProtection'
                            displayName = 'FakeStringValue'
                            guidedDeploymentTags = [string[]]@('FakeStringValue')
                        } -ClientOnly)
                    )
                    #>
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgbetaDeviceAppManagementPolicySet -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = "#microsoft.graph.PolicySet"
                        }
                        CreatedDateTime = "2023-01-01T00:00:00.0000000+00:00"
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        ErrorCode = "noError"
                        GuidedDeploymentTags = @("FakeStringValue")
                        Id = "FakeStringValue"
                        LastModifiedDateTime = "2023-01-01T00:00:00.0000000+00:00"
                        RoleScopeTags = @("FakeStringValue")
                        Status = "unknown"
                        Assignments = @(
                            [pscustomobject]@{
                                            Target = [pscustomobject]@{
                                                        AdditionalProperties = [pscustomobject]@{
                                                                                '@odata.type' = '#microsoft.graph.GroupAssignmentTarget'
                                                                                groupId = '12345678-1234-1234-1234-1234567890ab'
                                                                                }
                                                        DeviceAndAppManagementAssignmentFilterType = 'none'
                                                        DeviceAndAppManagementAssignmentFilterId = $null

                                                    }
                                            }
                                        )
                        Items = @(
                            [pscustomobject]@{

                                            AdditionalProperties = [pscustomobject]@{
                                                                    '@odata.type' = '#microsoft.graph.managedAppProtectionPolicySetItem'
                                                                    }
                                            payloadId = 'T_12345678-1234-1234-1234-1234567890ab'
                                            itemType = '#microsoft.graph.androidManagedAppProtection'
                                            displayName = 'FakeStringValue'
                                            guidedDeploymentTags = @('FakeStringValue')

                                            }
                                        )

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The IntunePolicySets exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description = "UPDATED-FakeStringValue"
                    DisplayName = "FakeStringValue"
                    GuidedDeploymentTags = @("FakeStringValue")
                    Id = "FakeStringValue"
                    RoleScopeTags = @("FakeStringValue")
                    Assignments = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyAssignments -Property @{
                            dataType                                   = '#microsoft.graph.GroupAssignmentTarget'
                            groupId                                    = '12345678-1234-1234-1234-1234567890ab'
                            deviceAndAppManagementAssignmentFilterType = 'none'
                        } -ClientOnly)
                    )
                    Items = [CimInstance[]]@(
                        (New-CimInstance -ClassName MSFT_DeviceManagementConfigurationPolicyItems -Property @{
                            dataType                                   = '#microsoft.graph.managedAppProtectionPolicySetItem'
                            payloadId                                    = 'T_12345678-1234-1234-1234-1234567890ab'
                            itemType = '#microsoft.graph.androidManagedAppProtection'
                            displayName = 'FakeStringValue'
                            guidedDeploymentTags = [string[]]@('FakeStringValue')
                        } -ClientOnly)
                    )
                    Ensure = 'Present'
                    Credential = $Credential;
                }

                Mock -CommandName Get-MgbetaDeviceAppManagementPolicySet -MockWith {
                    return @{
                        CreatedDateTime = "2023-01-01T00:00:00.0000000+00:00"
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        ErrorCode = "noError"
                        GuidedDeploymentTags = @("FakeStringValue")
                        Id = "FakeStringValue"
                        LastModifiedDateTime = "2023-01-01T00:00:00.0000000+00:00"
                        RoleScopeTags = @("FakeStringValue")
                        Status = "unknown"
                        Assignments = @(
                            [pscustomobject]@{
                                            Target = [pscustomobject]@{
                                                        AdditionalProperties = [pscustomobject]@{
                                                                                '@odata.type' = '#microsoft.graph.GroupAssignmentTarget'
                                                                                groupId = '12345678-1234-1234-1234-1234567890ab'
                                                                                }
                                                        DeviceAndAppManagementAssignmentFilterType = 'none'
                                                        DeviceAndAppManagementAssignmentFilterId = $null

                                                    }
                                            }
                                        )
                        Items = @(
                            [pscustomobject]@{

                                            AdditionalProperties = [pscustomobject]@{
                                                                    '@odata.type' = '#microsoft.graph.managedAppProtectionPolicySetItem'
                                                                    }
                                            payloadId = 'T_12345678-1234-1234-1234-1234567890ab'
                                            itemType = '#microsoft.graph.androidManagedAppProtection'
                                            displayName = 'FakeStringValue'
                                            guidedDeploymentTags = @('FakeStringValue')

                                            }
                                        )
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
                Should -Invoke -CommandName Update-MgbetaDeviceAppManagementPolicySet -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgbetaDeviceAppManagementPolicySet -MockWith {
                    return @{
                        AdditionalProperties = @{
                            '@odata.type' = "#microsoft.graph.PolicySet"
                        }
                        CreatedDateTime = "2023-01-01T00:00:00.0000000+00:00"
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        ErrorCode = "noError"
                        GuidedDeploymentTags = @("FakeStringValue")
                        Id = "FakeStringValue"
                        LastModifiedDateTime = "2023-01-01T00:00:00.0000000+00:00"
                        RoleScopeTags = @("FakeStringValue")
                        Status = "unknown"
                        Assignments = @(
                            [pscustomobject]@{
                                            Target = [pscustomobject]@{
                                                        AdditionalProperties = [pscustomobject]@{
                                                                                '@odata.type' = '#microsoft.graph.GroupAssignmentTarget'
                                                                                groupId = '12345678-1234-1234-1234-1234567890ab'
                                                                                }
                                                        DeviceAndAppManagementAssignmentFilterType = 'none'
                                                        DeviceAndAppManagementAssignmentFilterId = $null

                                                    }
                                            }
                                        )
                        Items = @(
                            [pscustomobject]@{

                                            AdditionalProperties = [pscustomobject]@{
                                                                    '@odata.type' = '#microsoft.graph.managedAppProtectionPolicySetItem'
                                                                    }
                                            payloadId = 'T_12345678-1234-1234-1234-1234567890ab'
                                            itemType = '#microsoft.graph.androidManagedAppProtection'
                                            displayName = 'FakeStringValue'
                                            guidedDeploymentTags = @('FakeStringValue')

                                            }
                                        )
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
