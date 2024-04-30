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
    -DscResource 'AADSelfservicePurchase' -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {
            $secpasswd = ConvertTo-SecureString (New-Guid | Out-String) -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ('tenantadmin@mydomain.com', $secpasswd)

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return 'Credentials'
            }

            Mock -CommandName Update-MSCommerceProductPolicy -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'SelfServicePurchase should be enabled but it is not' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    IsEnabled        = $True
                    Credential       = $Credscredential
                }

                Mock -CommandName Get-MSCommercePolicy -MockWith {
                    return @{
                        PolicyId     = 'AllowSelfServicePurchase'
                        Description  = 'fake description'
                        DefaultValue = 'False'
                    }
                }

                Mock -CommandName Get-MSCommerceProductPolicies -ParameterFilter "$null -eq $Scope" -MockWith {
                }
                Mock -CommandName Get-MSCommerceProductPolicies -ParameterFilter "$null  -ne $Scope" -MockWith {
                    @(
                        [pscustomobject]@{
                            PolicyId    = 'fake id 1'
                            PolicyValue = 'True'
                            Scope       = 'Software as a Service'
                            ScopeValue  = 'True'
                            ScopeId     = 'SaaS'
                        },
                        [pscustomobject]@{
                            PolicyId    = 'fake id 2'
                            PolicyValue = 'True'
                            Scope       = 'Power BI Visuals'
                            ScopeValue  = 'True'
                            ScopeId     = 'POWERBIVISUALS'
                        }
                    )
                }
            }

            It 'Should return values from the get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-MSCommercePolicy' -Exactly 1
                Should -Invoke -CommandName 'Get-MSCommerceProductPolicies' -Exactly 2
            }
            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $false
            }
            It 'Should Enable SelfServicePurchase from the set method' {
                Set-TargetResource @testParams |
                Should -Invoke -CommandName 'Update-MSCommerceProductPolicy' -Exactly 1
            }
        }
        Context -Name 'SelfServicePurchase should be enabled and it already is' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    IsEnabled        = $True
                    Credential       = $Credscredential
                }

                Mock -CommandName Get-MSCommercePolicy -MockWith {
                    return @{
                        PolicyId     = 'AllowSelfServicePurchase'
                        Description  = 'fake description'
                        DefaultValue = 'False'
                    }
                }

                Mock -CommandName Get-MSCommerceProductPolicies -ParameterFilter "$null -eq $Scope" -MockWith {
                }
                Mock -CommandName Get-MSCommerceProductPolicies -ParameterFilter "$null  -ne $Scope" -MockWith {
                    @(
                        [pscustomobject]@{
                            PolicyId    = 'fake id 1'
                            PolicyValue = 'True'
                            Scope       = 'Software as a Service'
                            ScopeValue  = 'True'
                            ScopeId     = 'SaaS'
                        },
                        [pscustomobject]@{
                            PolicyId    = 'fake id 2'
                            PolicyValue = 'True'
                            Scope       = 'Power BI Visuals'
                            ScopeValue  = 'True'
                            ScopeId     = 'POWERBIVISUALS'
                        }
                    )
                }
            }

            It 'Should return values from the get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-MSCommercePolicy' -Exactly 1
                Should -Invoke -CommandName 'Get-MSCommerceProductPolicies' -Exactly 2
            }

            It 'Should return true from the test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }
        Context -Name 'SelfServicePurchase Scope SaaS should be disabled but it is not' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    IsEnabled        = $True
                    OfferTypes       = @{OfferType = 'SAAS'; IsEnabled = $true}
                    Credential       = $Credscredential
                }

                Mock -CommandName Get-MSCommercePolicy -MockWith {
                    return @{
                        PolicyId     = 'AllowSelfServicePurchase'
                        Description  = 'fake description'
                        DefaultValue = 'False'
                    }
                }

                Mock -CommandName Get-MSCommerceProductPolicies -ParameterFilter "$null -eq $Scope" -MockWith {
                }
                Mock -CommandName Get-MSCommerceProductPolicies -ParameterFilter "$null  -ne $Scope" -MockWith {
                    @(
                        [pscustomobject]@{
                            PolicyId    = 'fake id 1'
                            PolicyValue = 'True'
                            Scope       = 'Software as a Service'
                            ScopeValue  = 'True'
                            ScopeId     = 'SaaS'
                        },
                        [pscustomobject]@{
                            PolicyId    = 'fake id 2'
                            PolicyValue = 'True'
                            Scope       = 'Power BI Visuals'
                            ScopeValue  = 'True'
                            ScopeId     = 'POWERBIVISUALS'
                        }
                    )
                }
            }

            It 'Should return values from the get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-MSCommercePolicy' -Exactly 1
                Should -Invoke -CommandName 'Get-MSCommerceProductPolicies' -Exactly 2
            }

            It 'Should return false from the test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
            It 'Should Enable SaaS SelfServicePurchase from the set method' {
                Set-TargetResource @testParams |
                Should -Invoke -CommandName 'Update-MSCommerceProductPolicy' -Exactly 2
            }
            Context -Name 'SelfServicePurchase All Scopes should be disabled but they are not' -Fixture {
                BeforeAll {
                    $testParams = @{
                        IsSingleInstance = 'Yes'
                        OfferTypes       = @{OfferType = 'All'; IsEnabled = $false}
                        Credential       = $Credscredential
                    }

                    Mock -CommandName Get-MSCommercePolicy -MockWith {
                        return @{
                            PolicyId     = 'AllowSelfServicePurchase'
                            Description  = 'fake description'
                            DefaultValue = 'False'
                        }
                    }

                    Mock -CommandName Get-MSCommerceProductPolicies -ParameterFilter "$null -eq $Scope" -MockWith {
                    }

                    Mock -CommandName Get-MSCommerceProductPolicy -ParameterFilter "$Scope -eq 'Software as a Service'" -MockWith {
                        PolicyId    = 'fake id 1'
                        PolicyValue = 'True'
                        Scope       = 'Software as a Service'
                        ScopeValue  = 'True'
                        ScopeId     = 'SaaS'
                    }
                    Mock -CommandName Get-MSCommerceProductPolicy -ParameterFilter "$Scope -eq 'Power BI Visuals'" -MockWith {
                        PolicyId    = 'fake id 2'
                        PolicyValue = 'False'
                        Scope       = 'Power BI Visuals'
                        ScopeValue  = 'False'
                        ScopeId     = 'POWERBIVISUALS'
                    }

                    Mock -CommandName Get-MSCommerceProductPolicies -ParameterFilter "$null -ne $Scope" -MockWith {
                        @(
                            [pscustomobject]@{
                                PolicyId    = 'fake id 1'
                                PolicyValue = 'True'
                                Scope       = 'Software as a Service'
                                ScopeValue  = 'True'
                                ScopeId     = 'SaaS'
                            },
                            [pscustomobject]@{
                                PolicyId    = 'fake id 2'
                                PolicyValue = 'false'
                                Scope       = 'Power BI Visuals'
                                ScopeValue  = 'false'
                                ScopeId     = 'POWERBIVISUALS'
                            }
                        )
                    }
                }

                It 'Should return values from the get method' {
                    Get-TargetResource @testParams
                    Should -Invoke -CommandName 'Get-MSCommercePolicy' -Exactly 1
                    Should -Invoke -CommandName 'Get-MSCommerceProductPolicies' -Exactly 2
                }

                It 'Should return false from the test method' {
                    Test-TargetResource @testParams | Should -Be $true
                }
                It 'Should Disable all SelfServicePurchase scopes from the set method' {
                    Set-TargetResource @testParams |
                    Should -Invoke -CommandName 'Update-MSCommerceProductPolicy' -Exactly 1
                }
            }
    }
}

Invoke-Command -ScriptBlock $Global:DscHelper.CleanupScript -NoNewScope
