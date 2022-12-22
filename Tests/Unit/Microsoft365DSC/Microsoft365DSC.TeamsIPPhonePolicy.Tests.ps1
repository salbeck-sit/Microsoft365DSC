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
    -DscResource "TeamsIPPhonePolicy" -GenericStubModule $GenericStubPath
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

            Mock -CommandName Set-CsTeamsIPPhonePolicy -MockWith {
            }

            Mock -CommandName New-CsTeamsIPPhonePolicy -MockWith {
            }

            Mock -CommandName Remove-CsTeamsIPPhonePolicy -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
        }
        # Test contexts
        Context -Name "The TeamsIPPhonePolicy should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowHotDesking                = $True
                    AllowBetterTogether            = "FakeStringValue"
                    SearchOnCommonAreaPhoneMode    = "FakeStringValue"
                    Description                    = "FakeStringValue"
                    HotDeskingIdleTimeoutInMinutes = 3
                    SignInMode                     = "FakeStringValue"
                    Identity                       = "FakeStringValue"
                    AllowHomeScreen                = "FakeStringValue"
                    Ensure                        = "Present"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-CsTeamsIPPhonePolicy -MockWith {
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
                Should -Invoke -CommandName New-CsTeamsIPPhonePolicy -Exactly 1
            }
        }

        Context -Name "The TeamsIPPhonePolicy exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowHotDesking                = $True
                    AllowBetterTogether            = "FakeStringValue"
                    SearchOnCommonAreaPhoneMode    = "FakeStringValue"
                    Description                    = "FakeStringValue"
                    HotDeskingIdleTimeoutInMinutes = 3
                    SignInMode                     = "FakeStringValue"
                    Identity                       = "FakeStringValue"
                    AllowHomeScreen                = "FakeStringValue"
                    Ensure                        = "Absent"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-CsTeamsIPPhonePolicy -MockWith {
                    return @{
                    AllowHotDesking                = $True
                    AllowBetterTogether            = "FakeStringValue"
                    SearchOnCommonAreaPhoneMode    = "FakeStringValue"
                    Description                    = "FakeStringValue"
                    HotDeskingIdleTimeoutInMinutes = 3
                    SignInMode                     = "FakeStringValue"
                    Identity                       = "FakeStringValue"
                    AllowHomeScreen                = "FakeStringValue"

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
                Should -Invoke -CommandName Remove-CsTeamsIPPhonePolicy -Exactly 1
            }
        }
        Context -Name "The TeamsIPPhonePolicy Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowHotDesking                = $True
                    AllowBetterTogether            = "FakeStringValue"
                    SearchOnCommonAreaPhoneMode    = "FakeStringValue"
                    Description                    = "FakeStringValue"
                    HotDeskingIdleTimeoutInMinutes = 3
                    SignInMode                     = "FakeStringValue"
                    Identity                       = "FakeStringValue"
                    AllowHomeScreen                = "FakeStringValue"
                    Ensure                        = "Present"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-CsTeamsIPPhonePolicy -MockWith {
                    return @{
                    AllowHotDesking                = $True
                    AllowBetterTogether            = "FakeStringValue"
                    SearchOnCommonAreaPhoneMode    = "FakeStringValue"
                    Description                    = "FakeStringValue"
                    HotDeskingIdleTimeoutInMinutes = 3
                    SignInMode                     = "FakeStringValue"
                    Identity                       = "FakeStringValue"
                    AllowHomeScreen                = "FakeStringValue"

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The TeamsIPPhonePolicy exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    AllowHotDesking                = $True
                    AllowBetterTogether            = "FakeStringValue"
                    SearchOnCommonAreaPhoneMode    = "FakeStringValue"
                    Description                    = "FakeStringValue"
                    HotDeskingIdleTimeoutInMinutes = 3
                    SignInMode                     = "FakeStringValue"
                    Identity                       = "FakeStringValue"
                    AllowHomeScreen                = "FakeStringValue"
                    Ensure                = "Present"
                    Credential            = $Credential;
                }

                Mock -CommandName Get-CsTeamsIPPhonePolicy -MockWith {
                    return @{
                    AllowHotDesking                = $False
                    AllowBetterTogether            = "FakeStringValueDrift #Drift"
                    SearchOnCommonAreaPhoneMode    = "FakeStringValueDrift #Drift"
                    Description                    = "FakeStringValueDrift #Drift"
                    HotDeskingIdleTimeoutInMinutes = 2
                    SignInMode                     = "FakeStringValueDrift #Drift"
                    Identity                       = "FakeStringValue"
                    AllowHomeScreen                = "FakeStringValueDrift #Drift"
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
                Should -Invoke -CommandName Set-CsTeamsIPPhonePolicy -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-CsTeamsIPPhonePolicy -MockWith {
                    return @{
                    AllowHotDesking                = $True
                    AllowBetterTogether            = "FakeStringValue"
                    SearchOnCommonAreaPhoneMode    = "FakeStringValue"
                    Description                    = "FakeStringValue"
                    HotDeskingIdleTimeoutInMinutes = 3
                    SignInMode                     = "FakeStringValue"
                    Identity                       = "FakeStringValue"
                    AllowHomeScreen                = "FakeStringValue"

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
