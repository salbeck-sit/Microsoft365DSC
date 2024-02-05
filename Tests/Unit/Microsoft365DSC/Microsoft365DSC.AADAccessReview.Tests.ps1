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
    -DscResource "AADAccessReview" -GenericStubModule $GenericStubPath
Describe -Name $Global:DscHelper.DescribeHeader -Fixture {
    InModuleScope -ModuleName $Global:DscHelper.ModuleName -ScriptBlock {
        Invoke-Command -ScriptBlock $Global:DscHelper.InitializeScript -NoNewScope
        BeforeAll {

            $secpasswd = ConvertTo-SecureString "test@password1" -AsPlainText -Force
            $Credential = New-Object System.Management.Automation.PSCredential ("tenantadmin@mydomain.com", $secpasswd)


            #Mock -CommandName Get-M365DSCExportContentForResource -MockWith {
            #}

            Mock -CommandName Confirm-M365DSCDependencies -MockWith {
            }

            Mock -CommandName Get-PSSession -MockWith {
            }

            Mock -CommandName Remove-PSSession -MockWith {
            }

            Mock -CommandName Update-MgIdentityGovernanceAccessReviewDefinition -MockWith {
            }

            Mock -CommandName New-MgIdentityGovernanceAccessReviewDefinition -MockWith {
            }

            Mock -CommandName Remove-MgIdentityGovernanceAccessReviewDefinition -MockWith {
            }

            Mock -CommandName New-M365DSCConnection -MockWith {
                return "Credential"
            }
        }
        # Test contexts
        Context -Name "The AADAccessReview should exist but it DOES NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                        DescriptionForAdmins = "FakeStringValue"
                        DescriptionForReviewers = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        FallbackReviewers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewReviewerScope -Property @{
                                query = "FakeStringValue"
                                queryRoot = "FakeStringValue"
                                queryType = "FakeStringValue"

                            } -ClientOnly)
                        )
                        Id = "FakeStringValue"
                        Reviewers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewReviewerScope -Property @{
                                query = "FakeStringValue"
                                queryRoot = "FakeStringValue"
                                queryType = "FakeStringValue"

                            } -ClientOnly)
                        )
                        Scope =(New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewScope -Property @{
                            query = "FakeStringValue"
                            queryType = "FakeStringValue"
                            queryRoot = "FakeStringValue"

                        } -ClientOnly)
                        Settings =(New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewScheduleSettings -Property @{
                            instanceDurationInDays = 25
                            defaultDecisionEnabled = $True
                            justificationRequiredOnApproval = $True
                            mailNotificationsEnabled = $True
                            defaultDecision = "FakeStringValue"
                            autoApplyDecisionsEnabled = $True
                            reminderNotificationsEnabled = $True
                            decisionHistoriesForReviewersEnabled = $True
                            recommendationsEnabled = $True

                        } -ClientOnly)
                        Status = "FakeStringValue"

                    Ensure                        = "Present"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgIdentityGovernanceAccessReviewDefinition -MockWith {
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
                Should -Invoke -CommandName New-MgIdentityGovernanceAccessReviewDefinition -Exactly 1
            }
        }

        Context -Name "The AADAccessReview exists but it SHOULD NOT" -Fixture {
            BeforeAll {
                $testParams = @{
                        DescriptionForAdmins = "FakeStringValue"
                        DescriptionForReviewers = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        FallbackReviewers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewReviewerScope -Property @{
                                query = "FakeStringValue"
                                queryRoot = "FakeStringValue"
                                queryType = "FakeStringValue"

                            } -ClientOnly)
                        )
                        Id = "FakeStringValue"
                        Reviewers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewReviewerScope -Property @{
                                query = "FakeStringValue"
                                queryRoot = "FakeStringValue"
                                queryType = "FakeStringValue"

                            } -ClientOnly)
                        )
                        Scope =(New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewScope -Property @{
                            query = "FakeStringValue"
                            queryType = "FakeStringValue"
                            queryRoot = "FakeStringValue"

                        } -ClientOnly)
                        Settings =(New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewScheduleSettings -Property @{
                            instanceDurationInDays = 25
                            defaultDecisionEnabled = $True
                            justificationRequiredOnApproval = $True
                            mailNotificationsEnabled = $True
                            defaultDecision = "FakeStringValue"
                            autoApplyDecisionsEnabled = $True
                            reminderNotificationsEnabled = $True
                            decisionHistoriesForReviewersEnabled = $True
                            recommendationsEnabled = $True

                        } -ClientOnly)
                        StageSettings =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphAccesReviewStageSettings -Property @{
                                stageId = "FakeStringValue"
                                recommendationsEnabled = $True
                                durationInDays = 25

                            } -ClientOnly)
                        )
                        Status = "FakeStringValue"

                    Ensure                        = "Absent"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgIdentityGovernanceAccessReviewDefinition -MockWith {
                    return @{
                        DescriptionForAdmins = "FakeStringValue"
                        DescriptionForReviewers = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        FallbackReviewers =@{
                                query = "FakeStringValue"
                                queryRoot = "FakeStringValue"
                                queryType = "FakeStringValue"

                            }
                        )
                        Id = "FakeStringValue"
                        Reviewers =@{
                                query = "FakeStringValue"
                                queryRoot = "FakeStringValue"
                                queryType = "FakeStringValue"

                            }
                        Scope =@{
                            query = "FakeStringValue"
                            queryType = "FakeStringValue"
                            '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                            queryRoot = "FakeStringValue"

                        }
                        Settings = @{
                            instanceDurationInDays = 25
                            defaultDecisionEnabled = $True
                            justificationRequiredOnApproval = $True
                            mailNotificationsEnabled = $True
                            defaultDecision = "FakeStringValue"
                            autoApplyDecisionsEnabled = $True
                            reminderNotificationsEnabled = $True
                            decisionHistoriesForReviewersEnabled = $True
                            recommendationsEnabled = $True

                        }
                        StageSettings =@(@{
                                stageId = "FakeStringValue"
                                recommendationsEnabled = $True
                                durationInDays = 25

                            }
                        )
                        Status = "FakeStringValue"

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
                Should -Invoke -CommandName Remove-MgIdentityGovernanceAccessReviewDefinition -Exactly 1
            }
        }
        Context -Name "The AADAccessReview Exists and Values are already in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                        AdditionalNotificationRecipients =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessreviewnotificationrecipientitem -Property @{
                                notificationTemplateType = "FakeStringValue"
                            } -ClientOnly)
                        )
                        DescriptionForAdmins = "FakeStringValue"
                        DescriptionForReviewers = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        FallbackReviewers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewReviewerScope -Property @{
                                query = "FakeStringValue"
                                queryRoot = "FakeStringValue"
                                queryType = "FakeStringValue"

                            } -ClientOnly)
                        )
                        Id = "FakeStringValue"
                        Reviewers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewReviewerScope -Property @{
                                query = "FakeStringValue"
                                queryRoot = "FakeStringValue"
                                queryType = "FakeStringValue"

                            } -ClientOnly)
                        )
                        Scope =(New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewScope -Property @{
                            query = "FakeStringValue"
                            queryType = "FakeStringValue"
                            queryRoot = "FakeStringValue"
                            odataType = "#microsoft.graph.accessReviewQueryScope"

                        } -ClientOnly)
                        Settings =(New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewScheduleSettings -Property @{
                            instanceDurationInDays = 25
                            defaultDecisionEnabled = $True
                            justificationRequiredOnApproval = $True
                            mailNotificationsEnabled = $True
                            defaultDecision = "FakeStringValue"
                            autoApplyDecisionsEnabled = $True
                            reminderNotificationsEnabled = $True
                            decisionHistoriesForReviewersEnabled = $True
                            recommendationsEnabled = $True

                        } -ClientOnly)
                        StageSettings =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewStageSettings -Property @{
                                stageId = "1"
                                recommendationsEnabled = $True
                                durationInDays = 25

                            } -ClientOnly)
                        )
                        Status = "FakeStringValue"

                    Ensure                        = "Present"
                    Credential                    = $Credential;
                }

                Mock -CommandName Get-MgIdentityGovernanceAccessReviewDefinition -MockWith {
                    return @{
                        AdditionalNotificationRecipients =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessreviewnotificationrecipientitem -Property @{
                                notificationTemplateType = "FakeStringValue"

                            } -ClientOnly)
                        )
                        CreatedBy =(New-CimInstance -ClassName MSFT_MicrosoftGraphuseridentity -Property @{
                            displayName = "FakeStringValue"
                            id = "FakeStringValue"
                            ipAddress = "FakeStringValue"
                            userPrincipalName = "FakeStringValue"

                        } -ClientOnly)
                        DescriptionForAdmins = "FakeStringValue"
                        DescriptionForReviewers = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        FallbackReviewers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewReviewerScope -Property @{
                                query = "FakeStringValue"
                                queryRoot = "FakeStringValue"
                                queryType = "FakeStringValue"

                            } -ClientOnly)
                        )
                        Id = "FakeStringValue"
                        Reviewers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewReviewerScope -Property @{
                                query = "FakeStringValue"
                                queryRoot = "FakeStringValue"
                                queryType = "FakeStringValue"

                            } -ClientOnly)
                        )
                        Scope =(New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewScope -Property @{
                            query = "FakeStringValue"
                            queryType = "FakeStringValue"
                            '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                            queryRoot = "FakeStringValue"

                        } -ClientOnly)
                        Settings =(New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewScheduleSettings -Property @{
                            instanceDurationInDays = 25
                            defaultDecisionEnabled = $True
                            justificationRequiredOnApproval = $True
                            mailNotificationsEnabled = $True
                            defaultDecision = "FakeStringValue"
                            autoApplyDecisionsEnabled = $True
                            reminderNotificationsEnabled = $True
                            decisionHistoriesForReviewersEnabled = $True
                            recommendationsEnabled = $True

                        } -ClientOnly)
                        StageSettings =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewStageSettings -Property @{
                                stageId = "FakeStringValue"
                                recommendationsEnabled = $True
                                durationInDays = 25

                            } -ClientOnly)
                        )
                        Status = "FakeStringValue"

                    }
                }
            }


            It 'Should return true from the Test method' {
                Test-TargetResource @testParams | Should -Be $true
            }
        }

        Context -Name "The AADAccessReview exists and values are NOT in the desired state" -Fixture {
            BeforeAll {
                $testParams = @{
                        AdditionalNotificationRecipients =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessreviewnotificationrecipientitem -Property @{
                                notificationTemplateType = "FakeStringValue"

                            } -ClientOnly)
                        )
                        DescriptionForAdmins = "FakeStringValue"
                        DescriptionForReviewers = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        FallbackReviewers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewReviewerScope -Property @{
                                query = "FakeStringValue"
                                queryRoot = "FakeStringValue"
                                queryType = "FakeStringValue"

                            } -ClientOnly)
                        )
                        Id = "FakeStringValue"
                        Reviewers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewReviewerScope -Property @{
                                query = "FakeStringValue"
                                queryRoot = "FakeStringValue"
                                queryType = "FakeStringValue"

                            } -ClientOnly)
                        )
                        Scope =(New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewScope -Property @{
                            query = "FakeStringValue"
                            queryType = "FakeStringValue"
                            queryRoot = "FakeStringValue"
                            odataType = "#microsoft.graph.accessReviewQueryScope"

                        } -ClientOnly)
                        Settings =(New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewScheduleSettings -Property @{
                            instanceDurationInDays = 25
                            defaultDecisionEnabled = $True
                            justificationRequiredOnApproval = $True
                            mailNotificationsEnabled = $True
                            defaultDecision = "FakeStringValue"
                            autoApplyDecisionsEnabled = $True
                            reminderNotificationsEnabled = $True
                            decisionHistoriesForReviewersEnabled = $True
                            recommendationsEnabled = $True

                        } -ClientOnly)
                        StageSettings =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewStageSettings -Property @{
                                stageId = "FakeStringValue"
                                recommendationsEnabled = $True
                                durationInDays = 25

                            } -ClientOnly)
                        )
                        Status = "FakeStringValue"

                    Ensure                = "Present"
                    Credential            = $Credential;
                }

                Mock -CommandName Get-MgIdentityGovernanceAccessReviewDefinition -MockWith {
                    return @{
                        AdditionalProperties =@{
                            Instances =@(
                                @{
                                isArray = $True

                                }
                            )
                            Scope =@{
                                query = "FakeStringValue"
                                queryType = "FakeStringValue"
                                '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                queryRoot = "FakeStringValue"

                            }
                            '@odata.type' = "#microsoft.graph."
                            StageSettings =@(
                                @{
                                    stageId = "FakeStringValue"
                                    recommendationsEnabled = $True
                                    durationInDays = 25

                                }
                            )
                            AdditionalNotificationRecipients =@(
                                @{
                                    notificationTemplateType = "FakeStringValue"

                                }
                            )
                            InstanceEnumerationScope =@{
                                query = "FakeStringValue"
                                queryType = "FakeStringValue"
                                '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                                queryRoot = "FakeStringValue"

                            }
                            DescriptionForReviewers = "FakeStringValue"
                            FallbackReviewers =@(
                                @{
                                    query = "FakeStringValue"
                                    queryRoot = "FakeStringValue"
                                    queryType = "FakeStringValue"

                                }
                            )
                            Status = "FakeStringValue"
                            Settings =@{
                                instanceDurationInDays = 25
                                defaultDecisionEnabled = $True
                                justificationRequiredOnApproval = $True
                                mailNotificationsEnabled = $True
                                defaultDecision = "FakeStringValue"
                                autoApplyDecisionsEnabled = $True
                                reminderNotificationsEnabled = $True
                                decisionHistoriesForReviewersEnabled = $True
                                recommendationsEnabled = $True

                            }
                            Reviewers =@(
                                @{
                                    query = "FakeStringValue"
                                    queryRoot = "FakeStringValue"
                                    queryType = "FakeStringValue"

                                }
                            )
                            DescriptionForAdmins = "FakeStringValue"
                            CreatedBy =@{
                                displayName = "FakeStringValue"
                                id = "FakeStringValue"
                                ipAddress = "FakeStringValue"
                                userPrincipalName = "FakeStringValue"

                            }

                        }
                        Description = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        Id = "FakeStringValue"

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
                Should -Invoke -CommandName Update-MgIdentityGovernanceAccessReviewDefinition -Exactly 1
            }
        }

        Context -Name "ReverseDSC Tests" -Fixture {
            BeforeAll {
                $Global:CurrentModeIsExport = $true
                $testParams = @{
                    Credential = $Credential
                }

                Mock -CommandName Get-MgIdentityGovernanceAccessReviewDefinition -MockWith {
                    return @{
                        AdditionalNotificationRecipients =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessreviewnotificationrecipientitem -Property @{
                                notificationTemplateType = "FakeStringValue"

                            } -ClientOnly)
                        )
                        CreatedBy =(New-CimInstance -ClassName MSFT_MicrosoftGraphuseridentity -Property @{
                            displayName = "FakeStringValue"
                            id = "FakeStringValue"
                            ipAddress = "FakeStringValue"
                            userPrincipalName = "FakeStringValue"

                        } -ClientOnly)
                        DescriptionForAdmins = "FakeStringValue"
                        DescriptionForReviewers = "FakeStringValue"
                        DisplayName = "FakeStringValue"
                        FallbackReviewers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewReviewerScope -Property @{
                                query = "FakeStringValue"
                                queryRoot = "FakeStringValue"
                                queryType = "FakeStringValue"

                            } -ClientOnly)
                        )
                        Id = "FakeStringValue"
                        InstanceEnumerationScope =(New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewScope -Property @{
                            query = "FakeStringValue"
                            queryType = "FakeStringValue"
                            '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                            queryRoot = "FakeStringValue"

                        } -ClientOnly)
                        Instances =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphaccessreviewinstance -Property @{
                            isArray = $True
                            CIMType = "MSFT_MicrosoftGraphaccessreviewinstance"

                            } -ClientOnly)
                        )
                        Reviewers =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewReviewerScope -Property @{
                                query = "FakeStringValue"
                                queryRoot = "FakeStringValue"
                                queryType = "FakeStringValue"

                            } -ClientOnly)
                        )
                        Scope =(New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewScope -Property @{
                            query = "FakeStringValue"
                            queryType = "FakeStringValue"
                            '@odata.type' = "#microsoft.graph.accessReviewQueryScope"
                            queryRoot = "FakeStringValue"

                        } -ClientOnly)
                        Settings =(New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewScheduleSettings -Property @{
                            instanceDurationInDays = 25
                            defaultDecisionEnabled = $True
                            justificationRequiredOnApproval = $True
                            mailNotificationsEnabled = $True
                            defaultDecision = "FakeStringValue"
                            autoApplyDecisionsEnabled = $True
                            reminderNotificationsEnabled = $True
                            decisionHistoriesForReviewersEnabled = $True
                            recommendationsEnabled = $True

                        } -ClientOnly)
                        StageSettings =@(
                            (New-CimInstance -ClassName MSFT_MicrosoftGraphAccessReviewStageSettings -Property @{
                                stageId = "FakeStringValue"
                                recommendationsEnabled = $True
                                durationInDays = 25

                            } -ClientOnly)
                        )
                        Status = "FakeStringValue"

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
