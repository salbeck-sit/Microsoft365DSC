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
    -DscResource "AADSocialIdentityProvider" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString "f@kepassword1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Update-MgBetaIdentityProvider -MockWith {
            }

            Mock -CommandName Remove-MgBetaIdentityProvider -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }
        # Test contexts
        Context -Name "The instance should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    ClientId             = "Google-OAUTH";
                    ClientSecret         = "FakeSecret";
                    DisplayName          = "My Google Provider";
                    Ensure               = "Present";
                    IdentityProviderType = "Google";
                    Credential           = $Credential;
                }

                Mock -CommandName Get-MgBetaIdentityProvider -MockWith {
                    return $null
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }
            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
        }

        Context -Name "The instance exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    ClientId             = "Google-OAUTH";
                    ClientSecret         = "FakeSecret";
                    DisplayName          = "My Google Provider";
                    Ensure               = "Absent";
                    IdentityProviderType = "Google";
                    Credential           = $Credential;
                }

                Mock -CommandName Get-MgBetaIdentityProvider -MockWith {
                    return @{
                        Id                   = "Google-OAUTH";
                        AdditionalProperties = @{
                            ClientId             = "Google-OAUTH";
                            ClientSecret         = "FakeSecret";
                            IdentityProviderType = "Google";
                            '@odata.type'        = "#microsoft.graph.socialIdentityProvider"
                        }
                        DisplayName          = "My Google Provider";
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
                Should -Invoke -CommandName Remove-MgBetaIdentityProvider -Exactly 1
            }
        }
        Context -Name "The instance exists and values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    ClientId             = "Google-OAUTH";
                    ClientSecret         = "FakeSecret";
                    DisplayName          = "My Google Provider";
                    Ensure               = "Present";
                    IdentityProviderType = "Google";
                    Credential           = $Credential;
                }

                Mock -CommandName Get-MgBetaIdentityProvider -MockWith {
                    return @{
                        Id                   = "Google-OAUTH";
                        AdditionalProperties = @{
                            ClientId             = "Google-OAUTH";
                            ClientSecret         = "FakeSecret";
                            IdentityProviderType = "Google";
                            '@odata.type'        = "#microsoft.graph.socialIdentityProvider"
                        }
                        DisplayName          = "My Google Provider";
                    }
                }
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The instance exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    ClientId             = "Google-OAUTH";
                    ClientSecret         = "FakeSecret";
                    DisplayName          = "My Google Provider";
                    Ensure               = "Present";
                    IdentityProviderType = "Google";
                    Credential           = $Credential;
                }

                Mock -CommandName Get-MgBetaIdentityProvider -MockWith {
                    return @{
                        Id                   = "Google-OAUTH";
                        AdditionalProperties = @{
                            ClientId             = "Google-OAUTH";
                            ClientSecret         = "FakeSecret";
                            IdentityProviderType = "Google";
                            '@odata.type'        = "#microsoft.graph.socialIdentityProvider"
                        }
                        DisplayName          = "My Drift Provider"; # Drift
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
                Should -Invoke -CommandName Update-MgBetaIdentityPRovider -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential  = $Credential;
                }

                Mock -CommandName Get-MgBetaIdentityProvider -MockWith {
                    return @{
                        Id                   = "Google-OAUTH";
                        AdditionalProperties = @{
                            ClientId             = "Google-OAUTH";
                            ClientSecret         = "FakeSecret";
                            IdentityProviderType = "Google";
                            '@odata.type'        = "#microsoft.graph.socialIdentityProvider"
                        }
                        DisplayName          = "My Google Provider";
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
