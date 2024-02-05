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
    -DscResource "EXORecipientPermission" -GenericStubModule $GenericStubPath
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

            Mock -CommandName Add-RecipientPermission -MockWith {
            }

            Mock -CommandName Remove-RecipientPermission -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }

            Mock -CommandName Get-MailBox -MockWith {
            }
            Mock -CommandName Get-MailUser -MockWith {
            }
            Mock -CommandName Get-MailContact -MockWith {
            }
            Mock -CommandName Get-DistributionGroup -MockWith {
            }
            Mock -CommandName Get-DynamicDistributionGroup -MockWith {
            }

            Mock -CommandName Get-MgGroup -MockWith {
            }

            # Mock Write-Host to hide output during the tests
            Mock -CommandName Write-Host -MockWith {
            }
        }
        # Test contexts
        Context -Name "The EXORecipientPermission trustee is a user and should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AccessRights = "SendAs"
                    Identity     = "FakeManager@fakedomain.com"
                    Trustee      = "FakeAssistant@fakedomain.com"
                    Ensure       = "Present"
                    Credential   = $Credential;
                }

                Mock -CommandName Get-RecipientPermission -MockWith {
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
                Should -Invoke -CommandName Add-RecipientPermission -Exactly 1
            }
        }

        Context -Name "The EXORecipientPermission trustee is a user and exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AccessRights = "SendAs"
                    Identity     = "FakeManager@fakedomain.com"
                    Trustee      = "FakeAssistant@fakedomain.com"
                    Ensure       = 'Absent'
                    Credential   = $Credential;
                }

                Mock -CommandName Get-RecipientPermission -MockWith {
                    return @(
                        @{
                            AccessRights          = @("SendAs")
                            Identity              = "FakeManager"
                            Trustee               = "FakeAssistant@fakedomain.com"
                        },
                        @{
                            AccessRights          = @("SendAs")
                            Identity              = "FakeManager"
                            Trustee               = "NT AUTHORITY/SELF"
                        }
                    )
                }
                Mock -CommandName Get-Mailbox -ParameterFilter {$Identity -eq 'FakeManager'} -MockWith {
                    return @{
                        WindowsEmailAddress = "FakeManager@fakedomain.com"
                    }
                }
            }

            It 'Should return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Present'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should Remove the permission from the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Remove-RecipientPermission -Exactly 1
            }
        }
        Context -Name "The EXORecipientPermission trustee is a user, Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AccessRights = "SendAs"
                    Identity     = "FakeManager@fakedomain.com"
                    Trustee      = "FakeAssistant@fakedomain.com"
                    Ensure       = 'Present'
                    Credential   = $Credential;
                }

                Mock -CommandName Get-RecipientPermission -MockWith {
                    return @(
                        @{
                            AccessRights          = @("SendAs")
                            Identity              = "FakeManager"
                            Trustee               = "FakeAssistant@contoso.com"
                        },
                        @{
                            AccessRights          = @("SendAs")
                            Identity              = "FakeManager"
                            Trustee               = "NT AUTHORITY\SELF"
                        }
                    )
                }
                Mock -CommandName Get-Mailbox -ParameterFilter {$Identity -eq 'FakeManager'} -MockWith {
                    return @{
                        WindowsEmailAddress = "FakeManager@fakedomain.com"
                    }
                }

            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The EXORecipientPermission trustee is a DL and does not exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    AccessRights = "SendAs"
                    Identity     = "FakeManager@fakedomain.com"
                    Trustee      = "FakeDL"
                    Ensure       = 'Present'
                    Credential = $Credential;
                }
                Mock -CommandName Get-RecipientPermission -MockWith {
                    return @(
                        @{
                            AccessRights          = @("SendAs")
                            Identity              = "FakeManager"
                            Trustee               = "NT AUTHORITY/SELF"
                        }
                    )
                }
                Mock -CommandName Get-Mailbox -ParameterFilter {$Identity -eq 'FakeManager'} -MockWith {
                    return @{
                        WindowsEmailAddress = "FakeManager@fakedomain.com"
                    }
                }
                Mock -CommandName Get-DistributionGroup -MockWith {
                    return @{
                        DisplayName = 'FakeDL'
                    }
                }
            }

            It 'Should NOT return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Add-RecipientPermission -Exactly 1
            }
        }

        Context -Name "The EXORecipientPermission trustee is a SecurityGroup and does not exist" -Fixture {
            BeforeAll {
                $testParams = @{
                    AccessRights = "SendAs"
                    Identity     = "FakeManager@fakedomain.com"
                    Trustee      = "FakeDL"
                    Ensure       = 'Present'
                    Credential = $Credential;
                }
                Mock -CommandName Get-RecipientPermission -MockWith {
                    return @(
                        @{
                            AccessRights          = @("SendAs")
                            Identity              = "FakeManager"
                            Trustee               = "NT AUTHORITY/SELF"
                        }
                    )
                }
                Mock -CommandName Get-Mailbox -ParameterFilter {$Identity -eq 'FakeManager'} -MockWith {
                    return @{
                        WindowsEmailAddress = "FakeManager@fakedomain.com"
                    }
                }
                Mock -CommandName Get-DistributionGroup -MockWith {
                    return @{
                        DisplayName = 'FakeDL'
                    }
                }
            }

            It 'Should NOT return Values from the Get method' {
                (Get-TargetResource @testParams).Ensure | Should -Be 'Absent'
            }

            It 'Should return false from the Test method' {
                Test-TargetResource @testParams | Should -Be $false
            }

            It 'Should call the Set method' {
                Set-TargetResource @testParams
                Should -Invoke -CommandName Add-RecipientPermission -Exactly 1
            }
        }

        Context -Name 'ReverseDSC Tests' -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $Global:PartialExportFileName = "$(New-Guid).partial.ps1"
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-RecipientPermission -MockWith {
                    return @(
                        @{
                            AccessRights          = @("SendAs")
                            Identity              = "FakeManager"
                            Trustee               = "FakeAssistant@fakedomain.com"
                        },
                        @{
                            AccessRights          = @("SendAs")
                            Identity              = "FakeManager"
                            Trustee               = "FakeSecurityGroup"
                            TrusteeSidString      = "<fake-sid-string>"
                        },
                        @{
                            AccessRights          = @("SendAs")
                            Identity              = "FakeManager"
                            Trustee               = "NT AUTHORITY/SELF"
                        }
                    )
                }
                Mock -CommandName Get-Mailbox -ParameterFilter {$Identity -eq 'FakeManager'} -MockWith {
                    return @{
                        WindowsEmailAddress = "FakeManager@fakedomain.com"
                    }
                }
                Mock -CommandName Get-MgGroup -MockWith {
                    return @(
                        @{
                            DisplayName        = 'IrrelevantSecurityGroup'
                            SecurityIdentifier = "<something-else>"
                        },
                        @{
                            DisplayName        = 'FakeSecurityGroup'
                            SecurityIdentifier = "<fake-sid-string>"
                        }
                    )
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
