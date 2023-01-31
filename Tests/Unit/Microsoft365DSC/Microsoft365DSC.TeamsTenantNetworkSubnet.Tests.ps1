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
    -DscResource "TeamsTenantNetworkSubnet" -GenericStubModule $GenericStubPath
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

            Mock -CommandName Set-CsTenantNetworkSubnet -MockWith {
            }

            Mock -CommandName New-CsTenantNetworkSubnet -MockWith {
            }

            Mock -CommandName Remove-CsTenantNetworkSubnet -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credentials"
            }
        }
        # Test contexts
        Context -Name "The TeamsTenantNetworkSubnet should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description          = "Nik Test";
                    Identity             = "192.168.0.0";
                    MaskBits             = 24;
                    NetworkSiteID        = "Nik";                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-CsTenantNetworkSubnet -MockWith {
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
                Should -Invoke -CommandName New-CsTenantNetworkSubnet -Exactly 1
            }
        }

        Context -Name "The TeamsTenantNetworkSubnet exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description          = "Nik Test";
                    Identity             = "192.168.0.0";
                    MaskBits             = 24;
                    NetworkSiteID        = "Nik";                    Ensure = "Absent"
                    Credential = $Credential;
                }

                Mock -CommandName Get-CsTenantNetworkSubnet -MockWith {
                    return @{
                    NetworkSiteID         = "FakeStringValue"
                    Description           = "FakeStringValue"
                    MaskBits              = 3
                    Identity              = "FakeStringValue"

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
                Should -Invoke -CommandName Remove-CsTenantNetworkSubnet -Exactly 1
            }
        }
        Context -Name "The TeamsTenantNetworkSubnet Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description          = "Nik Test";
                    Identity             = "192.168.0.0";
                    MaskBits             = 24;
                    NetworkSiteID        = "Nik";                    
                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-CsTenantNetworkSubnet -MockWith {
                    return @{
                    NetworkSiteID         = "Nik"
                    Description           = "Nik Test"
                    MaskBits              = 24
                    Identity              = "192.168.0.0"

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The TeamsTenantNetworkSubnet exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                    Description          = "Nik Test";
                    Identity             = "192.168.0.0";
                    MaskBits             = 24;
                    NetworkSiteID        = "Nik";                    Ensure = "Present"
                    Credential = $Credential;
                }

                Mock -CommandName Get-CsTenantNetworkSubnet -MockWith {
                    return @{
                    NetworkSiteID         = "FakeStringValueDrift #Drift"
                    Description           = "FakeStringValueDrift #Drift"
                    MaskBits              = 2
                    Identity              = "FakeStringValue"
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
                Should -Invoke -CommandName Set-CsTenantNetworkSubnet -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-CsTenantNetworkSubnet -MockWith {
                    return @{
                        NetworkSiteID         = "FakeStringValue"
                        Description           = "FakeStringValue"
                        MaskBits              = 3
                        Identity              = "FakeStringValue"
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
