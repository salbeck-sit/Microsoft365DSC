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
    -DscResource 'AADPasswordRuleSettings' -GenericStubModule $GenericStubPath
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

            Mock -CommandName Update-MgBetaDirectorySetting -MockWith {
            }

            Mock -CommandName Remove-MgBetaDirectorySetting -MockWith {
            }

            Mock -CommandName New-MgBetaDirectorySetting -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
            $Script:exportedInstances =$null
            $Script:ExportMode = $false
        }

        # Test contexts
        Context -Name 'The Policy should exist but it DOES NOT' -Fixture {
            BeforeAll {
                $Script:calledOnceAlready = $false
                $testParams = @{
                    BannedPasswordCheckOnPremisesMode   = 'Audit'
                    EnableBannedPasswordCheckOnPremises = $false
                    EnableBannedPasswordCheck           = $false
                    LockoutDurationInSeconds            = 30
                    LockoutThreshold                    = 6
                    Ensure                              = 'Present'
                    Credential                          = $Credential
                    IsSingleInstance                    = 'Yes'
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }
            }

            BeforeEach {
                Mock -CommandName Get-MgBetaDirectorySetting -MockWith {
                    if (-not $Script:calledOnceAlready)
                    {
                        $Script:calledOnceAlready = $true
                        return $null
                    }
                    else
                    {
                        return @{
                            DisplayName = 'Password Rule Settings'
                            Id          = '123456-1234-1234-1234-123456789012'
                            TemplateId  = '5cf42378-d67d-4f36-ba46-e8b86229381d'
                            Values      = @(
                                @{
                                    Name  = 'BannedPasswordCheckOnPremisesMode'
                                    Value = 'Audit'
                                },
                                @{
                                    Name  = 'EnableBannedPasswordCheckOnPremises'
                                    Value = $true
                                },
                                @{
                                    Name  = 'EnableBannedPasswordCheck'
                                    Value = $true
                                },
                                @{
                                    Name  = 'LockoutDurationInSeconds'
                                    Value = 60
                                },
                                @{
                                    Name  = 'LockoutThreshold'
                                    Value = 10
                                },
                                @{
                                    Name  = 'BannedPasswordList'
                                    Value = $null
                                }
                            )
                        }
                    }
                }
            }
            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
                Should -Invoke -CommandName 'Get-MgBetaDirectorySetting' -Exactly 1
            }

            It 'Should return true from the Test method' {
                $Script:calledOnceAlready = $false
                Test-TargetResource @testParams | Should -Be $false
            }
            BeforeEach {
                Mock -CommandName Get-MgBetaDirectorySetting -MockWith {
                    if (-not $Script:calledOnceAlready)
                    {
                        $Script:calledOnceAlready = $true
                        return $null
                    }
                    else
                    {
                        return @{
                            DisplayName = 'Password Rule Settings'
                            Id          = '123456-1234-1234-1234-123456789012'
                            TemplateId  = '5cf42378-d67d-4f36-ba46-e8b86229381d'
                            Values      = @(
                                @{
                                    Name  = 'BannedPasswordCheckOnPremisesMode'
                                    Value = 'Audit'
                                },
                                @{
                                    Name  = 'EnableBannedPasswordCheckOnPremises'
                                    Value = $true
                                },
                                @{
                                    Name  = 'EnableBannedPasswordCheck'
                                    Value = $true
                                },
                                @{
                                    Name  = 'LockoutDurationInSeconds'
                                    Value = 60
                                },
                                @{
                                    Name  = 'LockoutThreshold'
                                    Value = 10
                                },
                                @{
                                    Name  = 'BannedPasswordList'
                                    Value = $null
                                }
                            )
                        }
                    }
                }
            }
            It 'Should create and set the settings in the Set method' {
                $Script:calledOnceAlready = $false
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'New-MgBetaDirectorySetting' -Exactly 1
                Should -Invoke -CommandName 'Update-MgBetaDirectorySetting' -Exactly 1
            }
        }

        Context -Name 'The Policy exists but it SHOULD NOT' -Fixture {
            BeforeAll {
                $testParams = @{
                    IsSingleInstance = 'Yes'
                    Ensure           = 'Absent'
                    Credential       = $Credential
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-MgBetaDirectorySetting -MockWith {
                    return @{
                        DisplayName   = 'Password Rule Settings'
                        Id            = '123456-1234-1234-1234-123456789012'
                        TemplateId    = '5cf42378-d67d-4f36-ba46-e8b86229381d'
                        Values        = @(
                            @{
                                Name  = 'BannedPasswordCheckOnPremisesMode'
                                Value = 'Audit'
                            },
                            @{
                                Name  = 'EnableBannedPasswordCheckOnPremises'
                                Value = $true
                            },
                            @{
                                Name  = 'EnableBannedPasswordCheck'
                                Value = $true
                            },
                            @{
                                Name  = 'LockoutDurationInSeconds'
                                Value = 60
                            },
                            @{
                                Name  = 'LockoutThreshold'
                                Value = 10
                            },
                            @{
                                Name  = 'BannedPasswordList'
                                Value = $null
                            }
                        )
                        }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
                Should -Invoke -CommandName 'Get-MgBetaDirectorySetting' -Exactly 1
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Prevent Remove the Policy from the Set method' {
                { Set-TargetResource @testParams } | Should -Throw 'The AADPasswordRuleSettings resource cannot delete existing Directory Setting entries. Please specify Present.'
            }
        }
        Context -Name 'The Policy Exists and Values are already in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    BannedPasswordCheckOnPremisesMode   = 'Audit'
                    EnableBannedPasswordCheckOnPremises = $false
                    EnableBannedPasswordCheck           = $false
                    LockoutDurationInSeconds            = 30
                    LockoutThreshold                    = 6
                    BannedPasswordList                  = $null
                    Ensure                        = 'Present'
                    Credential                    = $Credential
                    IsSingleInstance              = 'Yes'
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-MgBetaDirectorySetting -MockWith {
                    return @{
                        DisplayName = 'Password Rule Settings'
                        Id          = '123456-1234-1234-1234-123456789012'
                        TemplateId  = '5cf42378-d67d-4f36-ba46-e8b86229381d'
                        Values      = @(
                            @{
                                Name  = 'BannedPasswordCheckOnPremisesMode'
                                Value = 'Audit'
                            },
                            @{
                                Name  = 'EnableBannedPasswordCheckOnPremises'
                                Value = $false
                            },
                            @{
                                Name  = 'EnableBannedPasswordCheck'
                                Value = $false
                            },
                            @{
                                Name  = 'LockoutDurationInSeconds'
                                Value = 30
                            },
                            @{
                                Name  = 'LockoutThreshold'
                                Value = 6
                            },
                            @{
                                Name  = 'BannedPasswordList'
                                Value = $null
                            }
                        )
                    }
                }

            }

            It 'Should return Values from the Get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-MgBetaDirectorySetting' -Exactly 1
            }

            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name 'Values are NOT in the desired state' -Fixture {
            BeforeAll {
                $testParams = @{
                    BannedPasswordCheckOnPremisesMode   = 'Audit'
                    EnableBannedPasswordCheckOnPremises = $false
                    EnableBannedPasswordCheck           = $false
                    LockoutDurationInSeconds            = 30
                    LockoutThreshold                    = 6
                    BannedPasswordList                  = $null
                    Ensure                              = 'Present'
                    Credential                          = $Credential
                    IsSingleInstance                    = 'Yes'
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
                }

                Mock -CommandName Get-MgBetaDirectorySetting -MockWith {
                    return @{
                        DisplayName = 'Password Rule Settings'
                        Id          = '123456-1234-1234-1234-123456789012'
                        TemplateId  = '5cf42378-d67d-4f36-ba46-e8b86229381d'
                        Values      = @(
                            @{
                                Name  = 'BannedPasswordCheckOnPremisesMode'
                                Value = 'Enforced'
                            },
                            @{
                                Name  = 'EnableBannedPasswordCheckOnPremises'
                                Value = $true
                            },
                            @{
                                Name  = 'EnableBannedPasswordCheck'
                                Value = $true
                            },
                            @{
                                Name  = 'LockoutDurationInSeconds'
                                Value = 60
                            },
                            @{
                                Name  = 'LockoutThreshold'
                                Value = 10
                            },
                            @{
                                Name  = 'BannedPasswordList'
                                Value = $null
                            }
                        )
                    }
                }
            }

            It 'Should return Values from the Get method' {
                Get-TargetResource @testParams
                Should -Invoke -CommandName 'Get-MgBetaDirectorySetting' -Exactly 1
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName 'Update-MgBetaDirectorySetting' -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgBetaDirectorySetting -MockWith {
                    return @{
                        DisplayName = 'Password Rule Settings'
                        Id          = '123456-1234-1234-1234-123456789012'
                        TemplateId  = '5cf42378-d67d-4f36-ba46-e8b86229381d'
                        Values      = @(
                            @{
                                Name  = 'BannedPasswordCheckOnPremisesMode'
                                Value = 'Audit'
                            },
                            @{
                                Name  = 'EnableBannedPasswordCheckOnPremises'
                                Value = $false
                            },
                            @{
                                Name  = 'EnableBannedPasswordCheck'
                                Value = $false
                            },
                            @{
                                Name  = 'LockoutDurationInSeconds'
                                Value = 30
                            },
                            @{
                                Name  = 'LockoutThreshold'
                                Value = 6
                            },
                            @{
                                Name  = 'BannedPasswordList'
                                Value = $null
                            }
                        )
                    }
                }

                Mock -CommandName New-M365DSCConnection -MockWith {
                    return 'Credentials'
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
