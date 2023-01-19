[CmdletBinding()]
param(
)
$M365DSCTestFolder = Join-Path -Path $PSScriptRoot `
                        -ChildPath "..\..\Unit" `
                        -Resolve
$CmdletModule = (Join-Path -Path $M365DSCTestFolder `
            -ChildPath "\Stubs\Microsoft365.psm1" `
            -Resolve)
$GenericStubPath = (Join-Path -Path $M365DSCTestFolder `
    -ChildPath "\Stubs\Generic.psm1" `
    -Resolve)
Import-Module -Name (Join-Path -Path $M365DSCTestFolder `
        -ChildPath "\UnitTestHelper.psm1" `
        -Resolve)

$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource "TeamsComplianceRecordingPolicy" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString "f@kepassword1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin@mydomain.com", $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Set-CsTeamsComplianceRecordingPolicy -MockWith {
            }

            Mock -CommandName New-CsTeamsComplianceRecordingPolicy -MockWith {
            }

            Mock -CommandName Remove-CsTeamsComplianceRecordingPolicy -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
        }
        # Test contexts
        Context -Name "The TeamsComplianceRecordingPolicy should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    WarnUserOnRemoval                                   = $True
                    Description                                         = "FakeStringValue"
                    Enabled                                             = $True
                    DisableComplianceRecordingAudioNotificationForCalls = $True
                    ComplianceRecordingApplications                     = "FakeStringValue"
                    Identity                                            = "FakeStringValue"
                    Ensure                        = "Present"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-CsTeamsComplianceRecordingPolicy -MockWith {
                    return $null
                }
            }
            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Create the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName New-CsTeamsComplianceRecordingPolicy -Exactly 1
            }
        }

        Context -Name "The TeamsComplianceRecordingPolicy exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    WarnUserOnRemoval                                   = $True
                    Description                                         = "FakeStringValue"
                    Enabled                                             = $True
                    DisableComplianceRecordingAudioNotificationForCalls = $True
                    ComplianceRecordingApplications                     = "FakeStringValue"
                    Identity                                            = "FakeStringValue"
                    Ensure                        = "Absent"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-CsTeamsComplianceRecordingPolicy -MockWith {
                    return @{
                    WarnUserOnRemoval                                   = $True
                    Description                                         = "FakeStringValue"
                    Enabled                                             = $True
                    DisableComplianceRecordingAudioNotificationForCalls = $True
                    ComplianceRecordingApplications                     = "FakeStringValue"
                    Identity                                            = "FakeStringValue"

                    }
                }
            }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the group from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-CsTeamsComplianceRecordingPolicy -Exactly 1
            }
        }
        Context -Name "The TeamsComplianceRecordingPolicy Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    WarnUserOnRemoval                                   = $True
                    Description                                         = "FakeStringValue"
                    Enabled                                             = $True
                    DisableComplianceRecordingAudioNotificationForCalls = $True
                    ComplianceRecordingApplications                     = "FakeStringValue"
                    Identity                                            = "FakeStringValue"
                    Ensure                        = "Present"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-CsTeamsComplianceRecordingPolicy -MockWith {
                    return @{
                    WarnUserOnRemoval                                   = $True
                    Description                                         = "FakeStringValue"
                    Enabled                                             = $True
                    DisableComplianceRecordingAudioNotificationForCalls = $True
                    ComplianceRecordingApplications                     = "FakeStringValue"
                    Identity                                            = "FakeStringValue"

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The TeamsComplianceRecordingPolicy exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    WarnUserOnRemoval                                   = $True
                    Description                                         = "FakeStringValue"
                    Enabled                                             = $True
                    DisableComplianceRecordingAudioNotificationForCalls = $True
                    ComplianceRecordingApplications                     = "FakeStringValue"
                    Identity                                            = "FakeStringValue"
                    Ensure                = "Present"
                    Credential            = $Credential;
                }

                Mock -CommandName Get-CsTeamsComplianceRecordingPolicy -MockWith {
                    return @{
                    WarnUserOnRemoval                                   = $False
                    Description                                         = "FakeStringValueDrift #Drift"
                    Enabled                                             = $False
                    DisableComplianceRecordingAudioNotificationForCalls = $False
                    ComplianceRecordingApplications                     = "FakeStringValueDrift #Drift"
                    Identity                                            = "FakeStringValue"
                    }
                }
            }

            It "Should return Values from the Get method" {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It "Should call the Set method" {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Set-CsTeamsComplianceRecordingPolicy -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-CsTeamsComplianceRecordingPolicy -MockWith {
                    return @{
                    WarnUserOnRemoval                                   = $True
                    Description                                         = "FakeStringValue"
                    Enabled                                             = $True
                    DisableComplianceRecordingAudioNotificationForCalls = $True
                    ComplianceRecordingApplications                     = "FakeStringValue"
                    Identity                                            = "FakeStringValue"

                    }
                }
            }
            It "Should Reverse Engineer resource from the Export method" {
                Export-TargetResource @testParams
            }
        }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
