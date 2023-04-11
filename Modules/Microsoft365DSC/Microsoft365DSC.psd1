#
# Module manifest for module 'Microsoft365DSC'
#
# Generated by: Microsoft Corporation
#
# Generated on: 2023-04-05

@{

  # Script module or binary module file associated with this manifest.
  # RootModule = ''

  # Version number of this module.
  ModuleVersion     = '1.23.405.1'

  # Supported PSEditions
  # CompatiblePSEditions = @()

  # ID used to uniquely identify this module
  GUID              = '39f599a6-d212-4480-83b3-a8ea2124d8cf'

  # Author of this module
  Author            = 'Microsoft Corporation'

  # Company or vendor of this module
  CompanyName       = 'Microsoft Corporation'

  # Copyright statement for this module
  Copyright         = '(c) 2023 Microsoft Corporation. All rights reserved.'

  # Description of the functionality provided by this module
  Description       = 'This DSC module is used to configure and monitor Microsoft tenants, including SharePoint Online, Exchange, Teams, etc.'

  # Minimum version of the PowerShell engine required by this module
  PowerShellVersion = '5.1'

  # Name of the PowerShell host required by this module
  # PowerShellHostName = ''

  # Minimum version of the PowerShell host required by this module
  # PowerShellHostVersion = ''

  # Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
  # DotNetFrameworkVersion = ''

  # Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
  # CLRVersion = ''

  # Processor architecture (None, X86, Amd64) required by this module
  # ProcessorArchitecture = ''

  # Modules that must be imported into the global environment prior to importing this module
  RequiredModules   = @()

  # Assemblies that must be loaded prior to importing this module
  # RequiredAssemblies = @()

  # Script files (.ps1) that are run in the caller's environment prior to importing this module.
  # ScriptsToProcess = @()

  # Type files (.ps1xml) to be loaded when importing this module
  # TypesToProcess = @()

  # Format files (.ps1xml) to be loaded when importing this module
  # FormatsToProcess = @()

  # Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
  NestedModules     = @(
    'modules\M365DSCAgent.psm1',
    'modules\M365DSCDocGenerator.psm1',
    'modules\M365DSCErrorHandler.psm1',
    'modules\M365DSCLogEngine.psm1',
    'modules\M365DSCPermissions.psm1',
    'modules\M365DSCReport.psm1',
    'modules\M365DSCReverse.psm1',
    'modules\M365DSCStubsUtility.psm1',
    'modules\M365DSCTelemetryEngine.psm1',
    'modules\M365DSCUtil.psm1',
    'modules\EncodingHelpers\M365DSCEmojis.psm1',
    'modules\EncodingHelpers\M365DSCStringEncoding.psm1'
  )

  # Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
  #FunctionsToExport = @()

  # Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
  CmdletsToExport   = @('Assert-M365DSCBlueprint',
    'Compare-M365DSCConfigurations',
    'Confirm-M365DSCDependencies',
    'Export-M365DSCConfiguration',
    'Export-M365DSCDiagnosticData',
    'Get-M365DSCNotificationEndPointRegistration',
    'Import-M365DSCDependencies',
    'New-M365DSCDeltaReport',
    'New-M365DSCNotificationEndPointRegistration',
    'New-M365DSCReportFromConfiguration',
    'New-M365DSCStubFiles',
    'Remove-M365DSCNotificationEndPointRegistration',
    'Set-M365DSCAgentCertificateConfiguration',
    'Start-M365DSCConfiguration',
    'Test-M365DSCAgent',
    'Test-M365DSCDependenciesForNewVersions',
    'Test-M365DSCModuleValidity',
    'Uninstall-M365DSCOutdatedDependencies',
    'Update-M365DSCAllowedGraphScopes',
    'Update-M365DSCAzureAdApplication',
    'Update-M365DSCDependencies',
    'Update-M365DSCModule',
    'Update-M365DSCResourceDocumentationPage',
    'Update-M365DSCResourcesSettingsJSON'
  )

  # Variables to export from this module
  # VariablesToExport = @()

  # Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
  AliasesToExport   = @()

  # List of all modules packaged with this module
  # ModuleList = @()

  # List of all files packaged with this module
  # FileList = @()

  # Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
  PrivateData       = @{

    PSData = @{
      # Tags applied to this module. These help with module discovery in online galleries.
      Tags         = 'DesiredStateConfiguration', 'DSC', 'DSCResourceKit', 'DSCResource', 'Microsoft365'

      # A URL to the license for this module.
      LicenseUri   = 'https://github.com/Microsoft/Microsoft365DSC/blob/master/LICENSE'

      # A URL to the main website for this project.
      ProjectUri   = 'https://github.com/Microsoft/Microsoft365DSC'

      # A URL to an icon representing this module.
      IconUri      = 'https://github.com/microsoft/Microsoft365DSC/blob/Dev/Modules/Microsoft365DSC/Dependencies/Images/Logo.png?raw=true'

      # ReleaseNotes of this module
      ReleaseNotes = '* IntuneDeviceEnrollmentPlatformRestriction
      * [BREAKING CHANGE] Updated resource to manage single and default platform restriction policies
        FIXES [#2347](https://github.com/microsoft/Microsoft365DSC/issues/2347)
    * IntuneDeviceConfigurationHealthMonitoringConfigurationPolicyWindows10
      * Initial Release
        FIXES [#2830](https://github.com/microsoft/Microsoft365DSC/issues/2830)
    * IntuneDeviceConfigurationNetworkBoundaryPolicyWindows10
      * Initial release
    * IntuneDeviceConfigurationPolicyWindows10
      * [BREAKING CHANGE] Added complex parameters as embedded CIM (DefenderDetectedMalwareActions, EdgeHomeButtonConfiguration, EdgeSearchEngine, NetworkProxyServer, Windows10AppsForceUpdateSchedule)
      * Resource regenerated with DRG
      * FIXES[#2867](https://github.com/microsoft/Microsoft365DSC/issues/2867)
      * FIXES[#2868](https://github.com/microsoft/Microsoft365DSC/issues/2868)
    * IntuneDeviceEnrollmentStatusPageWindows10
      * [BREAKING CHANGE] Renamed resource IntuneDeviceEnrollmentConfigurationWindows10 to IntuneDeviceEnrollmentStatusPageWindows10
      * Added support for property Assignments.
      * Added support for property Priority
      * FIXES [#2933](https://github.com/microsoft/Microsoft365DSC/issues/2933)
    * AADAdministrativeUnit
      * [BREAKING CHANGE] Setting Id as Key parameter and DisplayName as Required
      * Fixes extraction of the Members property.
      * Fixes extraction of the ScopedRoleMembers property.
    * AADApplication
      * [BREAKING CHANGE] Remove deprecated parameter Oauth2RequirePostResponse
    * AADAuthorizationPolicy
      * Fixes an error where the authentication method was not recognized when doing an export using app secret.
        FIXES [#3056](https://github.com/microsoft/Microsoft365DSC/issues/3056)
    * AADConditionalAccessPolicy
      * Add condition for empty External Guest/User include/exclude
        FIXES [#3108](https://github.com/microsoft/Microsoft365DSC/issues/3108)
      * [BREAKING CHANGE] Setting Id as Key parameter and DisplayName as Required
      * [BREAKING CHANGE] Remove deprecated parameters IncludeDevices and ExcludeDevices
    * AADEntitlementManagementAccessPackage, AADEntitlementManagementAccessPackageAssignmentPolicy,
      AADEntitlementManagementAccessPackageCatalog, AADEntitlementManagementAccessPackageCatalogResource,
      AADEntitlementManagementAccessPackageCatalogResource, AADEntitlementManagementConnectedOrganization,
      AADRoleSetting
      * [BREAKING CHANGE] Setting Id as Key parameter and DisplayName as Required
    * AADGroup
      * Changed the SecurityEnabled and MailEnabled parameters to become mandatory.
        FIXES [#3072](https://github.com/microsoft/Microsoft365DSC/issues/3072)
      * Stopped GroupTypes defaulting to "Unified" to allow creation of Security groups.
        FIXES [#3073](https://github.com/microsoft/Microsoft365DSC/issues/3073)
    * AADUser
      * [BREAKING CHANGE] Remove deprecated parameter PreferredDataLocation* EXOAntiPhishPolicy
      * [BREAKING CHANGE] Remove deprecated parameters EnableAntispoofEnforcement and
        TargetedDomainProtectionAction
    * EXOGroupSettings
      * Initial Release
        FIXES [#3089](https://github.com/microsoft/Microsoft365DSC/issues/3089)
    * EXOHostedContentFilterPolicy
      * [BREAKING CHANGE] Remove deprecated parameters EndUserSpamNotificationCustomFromAddress
        and EndUserSpamNotificationCustomFromName
    * EXOIRMConfiguration
      * [BREAKING CHANGE] Renamed unused Identity parameter to IsSingleInstance
        FIXES [#2969](https://github.com/microsoft/Microsoft365DSC/issues/2969)
    * EXOMalwareFilterPolicy
      * [BREAKING CHANGE] Remove deprecated parameters Action, CustomAlertText,
        EnableExternalSenderNotifications and EnableInternalSenderNotifications
    * EXOManagementRoleAssignment
      * Use Microsoft Graph to retrieve administrative units. This fixes the issue where a soft
        deleted AU was present while a new one got created with the same name.
        FIXES [#3064](https://github.com/microsoft/Microsoft365DSC/issues/3064)
    * EXOOrganizationConfig
      * [BREAKING CHANGE] Remove deprecated parameters AllowPlusAddressInRecipients
      * [BREAKING CHANGE] Renamed unused Identity parameter to IsSingleInstance
        FIXES [#2969](https://github.com/microsoft/Microsoft365DSC/issues/2969)
    * EXOPerimeterConfiguration
      * [BREAKING CHANGE] Renamed unused Identity parameter to IsSingleInstance
        FIXES [#2969](https://github.com/microsoft/Microsoft365DSC/issues/2969)
    * EXOResourceConfiguration
      * [BREAKING CHANGE] Renamed unused Identity parameter to IsSingleInstance
        FIXES [#2969](https://github.com/microsoft/Microsoft365DSC/issues/2969)
    * EXOSaveLinksPolicy
      * [BREAKING CHANGE] Remove deprecated parameters DoNotAllowClickThrough,
        DoNotTrackUserClicks and IsEnabled
    * EXOSharedMailbox
      * [BREAKING CHANGE] Remove deprecated parameter Aliases
    * EXOTransportRule
      * [BREAKING CHANGE] Remove deprecated parameter ExceptIfMessageContainsAllDataClassifications,
        IncidentReportOriginalMail and MessageContainsAllDataClassifications
    * IntuneAntivirusPolicyWindows10SettingCatalog, IntuneASRRulesPolicyWindows10,
      IntuneAppProtectionPolicyiOS, IntuneAttackSurfaceReductionRulesPolicyWindows10ConfigManager,
      IntuneSettingCatalogASRRulesPolicyWindows10
      * [BREAKING CHANGE] Setting Identity as Key parameter and DisplayName as Required
    * IntuneAttackSurfaceReductionRulesPolicyWindows10ConfigManager
      * [BREAKING CHANGE] Fix resource
    * IntuneDeviceConfigurationPolicyAndroidDeviceAdministrator, IntuneDeviceConfigurationPolicyAndroidDeviceOwner,
      IntuneDeviceConfigurationPolicyAndroidOpenSourceProject, IntuneDeviceConfigurationPolicyMacOS,
      IntuneDeviceConfigurationPolicyiOS, IntuneExploitProtectionPolicyWindows10SettingCatalog,
      IntuneWifiConfigurationPolicyAndroidDeviceAdministrator, IntuneWifiConfigurationPolicyAndroidForWork,
      IntuneWifiConfigurationPolicyAndroidOpenSourceProject, IntuneWifiConfigurationPolicyIOS,
      IntuneWifiConfigurationPolicyMacOS, IntuneWifiConfigurationPolicyWindows10,
      IntuneWindowsInformationProtectionPolicyWindows10MdmEnrolled, IntuneWindowsUpdateForBusinessFeatureUpdateProfileWindows10
      * [BREAKING CHANGE] Setting Id as Key parameter and DisplayName as Required
      * Properly escapes single quotes from CIMInstances string values.
        FIXES [#3117](https://github.com/microsoft/Microsoft365DSC/issues/3117)
    * IntuneWifiConfigurationPolicyAndroidEnterpriseDeviceOwner
      * [BREAKING CHANGE] Setting Id as Key parameter and DisplayName as Required
      * [BREAKING CHANGE] Corrected typo in resource name (Entreprise to Enterprise)
        FIXES [#3024](https://github.com/microsoft/Microsoft365DSC/issues/3024)
    * IntuneWifiConfigurationPolicyAndroidEnterpriseWorkProfile
      * [BREAKING CHANGE] Setting Id as Key parameter and DisplayName as Required
      * [BREAKING CHANGE] Corrected typo in resource name (Entreprise to Enterprise)
        FIXES [#3024](https://github.com/microsoft/Microsoft365DSC/issues/3024)
    * IntuneWindowsAutopilotDeploymentProfileAzureADJoined
      * Initial release
        FIXES [#2605](https://github.com/microsoft/Microsoft365DSC/issues/2605)
    * IntuneWindowsAutopilotDeploymentProfileAzureADHybridJoined
      * Initial release
        FIXES [#2605](https://github.com/microsoft/Microsoft365DSC/issues/2605)
    * IntuneWindowsUpdateForBusinessRingUpdateProfileWindows10
      * [BREAKING CHANGE] Setting Id as Key parameter and DisplayName as Required
      * [BREAKING CHANGE] Corrected typo in resource name (Window to Windows)
        FIXES [#3024](https://github.com/microsoft/Microsoft365DSC/issues/3024)
    * SCAuditConfigurationPolicy, SCAutoSensitivityLabelPolicy, SCCaseHoldPolicy, SCCaseHoldRule,
      SCComplianceCase, SCComplianceSearch, SCComplianceSearchAction, SCComplianceTag,
      SCDeviceConditionalAccessPolicy, SCDeviceConfigurationPolicy, SCDLPComplianceRule,
      SCFilePlanPropertyAuthority, SCFilePlanPropertyCategory, SCFilePlanPropertyCitation,
      SCFilePlanPropertyDepartment, SCFilePlanPropertyReferenceId, SCFilePlanPropertySubCategory,
      SCLabelPolicy, SCProtectionAlert, SCRetentionCompliancePolicy, SCRetentionComplianceRule,
      SCRetentionEventType, SCSupervisoryReviewPolicy, SCSupervisoryReviewRule
      * Fixed the collection of new and set parameters to ensure the correct values are passed to the New/Set cmdlets.
        FIXES [#3075](https://github.com/microsoft/Microsoft365DSC/issues/3075)
    * SCSensitivityLabel
      * [BREAKING CHANGE] Remove deprecated parameters Disabled, ApplyContentMarkingFooterFontName,
        ApplyContentMarkingHeaderFontName, ApplyWaterMarkingFontName and EncryptionAipTemplateScopes
    * SPOApp
      * Fixed issue in the Export where an error was displayed in Verbose mode when Credentials were specified
        and the apps were not exported.
    * SPOTenantSettings
      * [BREAKING CHANGE] Remove deprecated parameter RequireAcceptingAccountMatchInvitedAccount
      * Fixes how we are extracting the DisabledWebPartIds parameter.
        FIXES [#3066](https://github.com/microsoft/Microsoft365DSC/issues/3066)
    * TeamsGroupPolicyAssignment change of key and required parameters
      * [BREAKING CHANGE] Setting GroupId and PolicyType as Key parameters
        FIXES [#3054](https://github.com/microsoft/Microsoft365DSC/issues/3054)
    * TeamsMeetingPolicy
      * [BREAKING CHANGE] Remove deprecated parameter RecordingStorageMode
    * TeamsUpdateManagementPolicy
      * Added support for the new UseNewTeamsClient parameter.
        FIXES [#3062](https://github.com/microsoft/Microsoft365DSC/issues/3062)
    * DRG
      * Various fixes
        * Cleanup generated code
        * Fix AdditionalProperties complex constructor
        * Fix Read privileges in settings file
    * MISC
      * Fixed an issue `New-M365DSCReportFromConfiguration` where a non existing parameter was used to retrieve the configuration.
      * Improved unit test performance
      * Added a QA check to test for the presence of a Key parameter and fixes
        resources where this was not the case.
        FIXES [#2925](https://github.com/microsoft/Microsoft365DSC/issues/2925)
      * Major changes to the export process where resource instances will now be assigned a meaningful nam
        that will follow the ResourceName-PrimaryKey convention.
      * Added a fix making sure that the progress bar "Scanning dependencies" is no longer displayed after the operation is completed.
      * Added a new Set-M365DSCLoggingOption function to enable logging information about non-drifted resources in Event Viewer.
        FIXES [#2981](https://github.com/microsoft/Microsoft365DSC/issues/2981)
      * Updated the Update-M365DSCModule to unload dependencies before updating them and then to reload the new versions.
        FIXES [#3097](https://github.com/microsoft/Microsoft365DSC/issues/3097)
      * Added a new internal function to remove the authentication parameters from the bound paramters. `Remove-M365DSCAuthenticationParameter`
    * DEPENDENCIES
      * Updated Microsoft.Graph dependencies to version 1.25.0.
      * Updated MicrosoftTeams dependency to version 5.1.0.'

      # Flag to indicate whether the module requires explicit user acceptance for install/update
      # RequireLicenseAcceptance = $false

      # External dependent modules of this module
      # ExternalModuleDependencies = @()

    } # End of PSData hashtable

  } # End of PrivateData hashtable

  # HelpInfo URI of this module
  # HelpInfoURI = ''

  # Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
  # DefaultCommandPrefix = ''
}
