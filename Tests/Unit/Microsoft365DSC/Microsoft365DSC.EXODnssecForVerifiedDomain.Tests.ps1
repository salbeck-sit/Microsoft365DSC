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

$CurrentScriptPath = $PSCommandPath.Split('\')
$CurrentScriptName = $CurrentScriptPath[$CurrentScriptPath.Length -1]
$ResourceName      = $CurrentScriptName.Split('.')[1]
$Global:DscHelper = New-M365DscUnitTestHelper -StubModule $CmdletModule `
    -DscResource $ResourceName -GenericStubModule $GenericStubPath

Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock -CommandName Enable-DnssecForVerifiedDomain -MockWith {
                return $null
            }

            Mock -CommandName Disable-DnssecForVerifiedDomain -MockWith {
                return $null
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }
        # Test contexts
        Context -Name "The instance exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    DomainName          = 'test.com'
                    DnssecFeatureStatus = 'Enabled'
                    Credential          = $Credential;
                }

                Mock -CommandName Get-DnssecStatusForVerifiedDomain -MockWith {
                    return @{
                        DomainName          = 'test.com'
                        DnssecFeatureStatus = 'Enabled'
                        Credential          = $Credential;
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The instance exists and values are NOT in the desired state - Enable" -Fixture {
            BeforeAll {
                $testParams = @{
                    DomainName          = 'test.com'
                    DnssecFeatureStatus = 'Enabled'
                    Credential          = $Credential;
                }

                Mock -CommandName Get-DnssecStatusForVerifiedDomain -MockWith {
                    return @{
                        DomainName          = 'test.com'
                        DnssecFeatureStatus = 'Disabled'
                        Credential          = $Credential;
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).DnssecFeatureStatus | Should -Be 'Disabled'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Enable-DnssecForVerifiedDomain -Exactly 1
            }
        }

        Context -Name "The instance exists and values are NOT in the desired state - Disable" -Fixture {
            BeforeAll {
                $testParams = @{
                    DomainName          = 'test.com'
                    DnssecFeatureStatus = 'Disabled'
                    Credential          = $Credential;
                }

                Mock -CommandName Get-DnssecStatusForVerifiedDomain -MockWith {
                    return @{
                        DomainName          = 'test.com'
                        DnssecFeatureStatus = 'Enabled'
                        Credential          = $Credential;
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).DnssecFeatureStatus | Should -Be 'Enabled'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Disable-DnssecForVerifiedDomain -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential  = $Credential;
                }

                Mock -CommandName Get-DnssecStatusForVerifiedDomain -MockWith {
                    return @{
                        DomainName          = 'test.com'
                        DnssecFeatureStatus = 'Enabled'
                        Credential          = $Credential;
                    }
                }

                Mock -CommandName Get-AcceptedDomain -MockWith {
                    return @{
                        DomainName          = 'test.com'
                        Credential          = $Credential;
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
