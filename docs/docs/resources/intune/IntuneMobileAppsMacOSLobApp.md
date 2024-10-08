﻿# IntuneMobileAppsMacOSLobApp

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **DisplayName** | Key | String | The admin provided or imported title of the app. Inherited from mobileApp. | |
| **Id** | Write | String | The unique identifier for an entity. Read-only. Inherited from mobileApp object. | |
| **Description** | Write | String | The description of the app. Inherited from mobileApp. | |
| **Developer** | Write | String | The dewveloper of the app. Inherited from mobileApp. | |
| **InformationUrl** | Write | String | The InformationUrl of the app. Inherited from mobileApp. | |
| **IsFeatured** | Write | Boolean | The value indicating whether the app is marked as featured by the admin. Inherited from mobileApp. | |
| **Notes** | Write | String | Notes for the app. Inherited from mobileApp. | |
| **Owner** | Write | String | The owner of the app. Inherited from mobileApp. | |
| **PrivacyInformationUrl** | Write | String | The privacy statement Url. Inherited from mobileApp. | |
| **Publisher** | Write | String | The publisher of the app. Inherited from mobileApp. | |
| **PublishingState** | Write | String | The publishing state for the app. The app cannot be assigned unless the app is published. Inherited from mobileApp. | `notPublished`, `processing`, `published` |
| **BundleId** | Write | String | The bundleId of the app. | |
| **BuildNumber** | Write | String | The build number of the app. | |
| **VersionNumber** | Write | String | The version number of the app. | |
| **RoleScopeTagIds** | Write | StringArray[] | List of Scope Tag IDs for mobile app. | |
| **IgnoreVersionDetection** | Write | Boolean | Wether to ignore the version of the app or not. | |
| **LargeIcon** | Write | MSFT_DeviceManagementMimeContent | The icon for this app. | |
| **Categories** | Write | MSFT_DeviceManagementMobileAppCategory[] | The list of categories for this app. | |
| **Assignments** | Write | MSFT_DeviceManagementMobileAppAssignment[] | The list of assignments for this app. | |
| **ChildApps** | Write | MSFT_DeviceManagementMobileAppChildApp[] | The list of child apps for this app package. | |
| **Ensure** | Write | String | Present ensures the policy exists, absent ensures it is removed. | `Present`, `Absent` |
| **Credential** | Write | PSCredential | Credentials of the Admin | |
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. | |
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. | |
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. | |
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. | |
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. | |
| **AccessTokens** | Write | StringArray[] | Access token used for authentication. | |

### MSFT_DeviceManagementMimeContent

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **type** | Write | String | Indicates the type of content mime. | |
| **value** | Write | StringArray[] | The byte array that contains the actual content. | |

### MSFT_DeviceManagementMobileAppCategory

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **displayName** | Key | String | The name of the app category. | |
| **id** | Write | String | The unique identifier for an entity. Read-only. | |

### MSFT_DeviceManagementMobileAppChildApp

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **bundleId** | Write | String | The bundleId of the app. | |
| **buildNumber** | Write | String | The build number of the app. | |
| **versionNumber** | Write | String | The version number of the app. | |

### MSFT_DeviceManagementMobileAppAssignment

#### Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **dataType** | Write | String | The type of the target assignment. | `#microsoft.graph.groupAssignmentTarget`, `#microsoft.graph.allLicensedUsersAssignmentTarget`, `#microsoft.graph.allDevicesAssignmentTarget`, `#microsoft.graph.exclusionGroupAssignmentTarget`, `#microsoft.graph.mobileAppAssignment` |
| **deviceAndAppManagementAssignmentFilterId** | Write | String | The Id of the filter for the target assignment. | |
| **deviceAndAppManagementAssignmentFilterType** | Write | String | The type of filter of the target assignment i.e. Exclude or Include. Possible values are: none, include, exclude. | `none`, `include`, `exclude` |
| **groupId** | Write | String | The group Id that is the target of the assignment. | |
| **groupDisplayName** | Write | String | The group Display Name that is the target of the assignment. | |
| **intent** | Write | String | Possible values for the install intent chosen by the admin. | `available`, `required`, `uninstall`, `availableWithoutEnrollment` |
| **source** | Write | String | The source of this assignment. | |


## Description

This resource configures an Intune mobile app of MacOSLobApp type for MacOS devices.

## Permissions

### Microsoft Graph

To authenticate with the Microsoft Graph API, this resource required the following permissions:

#### Delegated permissions

- **Read**

    - DeviceManagementApps.Read.All

- **Update**

    - DeviceManagementApps.ReadWrite.All

#### Application permissions

- **Read**

    - DeviceManagementApps.Read.All

- **Update**

    - DeviceManagementApps.ReadWrite.All

## Examples

### Example 1

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Import-DscResource -ModuleName Microsoft365DSC
    node localhost
    {
        IntuneMobileAppsMacOSLobApp "IntuneMobileAppsMacOSLobApp-TeamsForBusinessInstaller"
        {
            Id                    = "8d027f94-0682-431e-97c1-827d1879fa79";
            Description           = "TeamsForBusinessInstaller";
            Developer             = "Contoso";
            DisplayName           = "TeamsForBusinessInstaller";
            Ensure                = "Present";
            InformationUrl        = "";
            IsFeatured            = $False;
            Notes                 = "";
            Owner                 = "";
            PrivacyInformationUrl = "";
            Publisher             = "Contoso";
            PublishingState       = "published";
            Assignments          = @(
                    MSFT_DeviceManagementMobileAppAssignment{
                            groupDisplayName = 'All devices'
                        source = 'direct'
                        deviceAndAppManagementAssignmentFilterType = 'none'
                        dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                        intent = 'required'
                    MSFT_DeviceManagementMobileAppAssignment{
                        deviceAndAppManagementAssignmentFilterType = 'none'
                        source = 'direct'
                        dataType = '#microsoft.graph.groupAssignmentTarget'
                        groupId = '57b5e81c-85bb-4644-a4fd-33b03e451c89'
                        intent = 'required'
                    }
                });
            Categories           = @(MSFT_DeviceManagementMobileAppCategory {
                    id  = '1bff2652-03ec-4a48-941c-152e93736515'
                    displayName = 'Kajal 3'
                });
        }
    }
}
```

### Example 2

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Import-DscResource -ModuleName Microsoft365DSC
    node localhost
    {
        IntuneMobileAppsMacOSLobApp "IntuneMobileAppsMacOSLobApp-TeamsForBusinessInstaller"
        {
            Id                    = "8d027f94-0682-431e-97c1-827d1879fa79";
            Description           = "TeamsForBusinessInstaller";
            Developer             = "Contoso drift"; #drift
            DisplayName           = "TeamsForBusinessInstaller";
            Ensure                = "Present";
            InformationUrl        = "";
            IsFeatured            = $False;
            Notes                 = "";
            Owner                 = "";
            PrivacyInformationUrl = "";
            Publisher             = "Contoso";
            PublishingState       = "published";
            Assignments          = @(
                    MSFT_DeviceManagementMobileAppAssignment{
                            groupDisplayName = 'All devices'
                        source = 'direct'
                        deviceAndAppManagementAssignmentFilterType = 'none'
                        dataType = '#microsoft.graph.allDevicesAssignmentTarget'
                        intent = 'required'
                    MSFT_DeviceManagementMobileAppAssignment{
                        deviceAndAppManagementAssignmentFilterType = 'none'
                        source = 'direct'
                        dataType = '#microsoft.graph.groupAssignmentTarget'
                        groupId = '57b5e81c-85bb-4644-a4fd-33b03e451c89'
                        intent = 'required'
                    }
                });
            Categories           = @(MSFT_DeviceManagementMobileAppCategory {
                    id  = '1bff2652-03ec-4a48-941c-152e93736515'
                    displayName = 'Kajal 3'
                });
        }
    }
}
```

### Example 3

This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.

```powershell
Configuration Example
{
    param(
        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.String]
        $CertificateThumbprint
    )

    Import-DscResource -ModuleName Microsoft365DSC
    node localhost
    {
        IntuneMobileAppsMacOSLobApp "IntuneMobileAppsMacOSLobApp-TeamsForBusinessInstaller"
        {
            Id                    = "8d027f94-0682-431e-97c1-827d1879fa79";
            Description           = "TeamsForBusinessInstaller";
            Developer             = "Contoso";
            DisplayName           = "TeamsForBusinessInstaller";
            Ensure                = "Absent";
            InformationUrl        = "";
            IsFeatured            = $False;
            Notes                 = "";
            Owner                 = "";
            PrivacyInformationUrl = "";
            Publisher             = "Contoso";
            PublishingState       = "published";
        }
    }
}
```

