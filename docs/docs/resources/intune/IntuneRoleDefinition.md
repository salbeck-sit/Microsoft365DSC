﻿# IntuneRoleDefinition

## Parameters

| Parameter | Attribute | DataType | Description | Allowed Values |
| --- | --- | --- | --- | --- |
| **Id** | Write | String | The unique idenfier for an entity. Read-only. ||
| **Description** | Write | String | Description of the Role definition. ||
| **DisplayName** | Key | String | Display Name of the Role definition. ||
| **IsBuiltIn** | Write | Boolean | Type of Role. Set to True if it is built-in, or set to False if it is a custom role definition. ||
| **allowedResourceActions** | Write | StringArray[] | List of allowed resource actions ||
| **notAllowedResourceActions** | Write | StringArray[] | List of not allowed resource actions ||
| **roleScopeTagIds** | Write | StringArray[] | Id of the Scope Tags to assign ||
| **Ensure** | Write | String | Present ensures the Role exists, absent ensures it is removed. |Present, Absent|
| **Credential** | Write | PSCredential | Credentials of the Intune Admin ||
| **ApplicationId** | Write | String | Id of the Azure Active Directory application to authenticate with. ||
| **TenantId** | Write | String | Id of the Azure Active Directory tenant used for authentication. ||
| **ApplicationSecret** | Write | PSCredential | Secret of the Azure Active Directory tenant used for authentication. ||
| **CertificateThumbprint** | Write | String | Thumbprint of the Azure Active Directory application's authentication certificate to use for authentication. ||
| **ManagedIdentity** | Write | Boolean | Managed ID being used for authentication. ||


# IntuneRoleDefinition

### Description

This resource configures an Intune Role Definition.

## Examples

### Example 1

This example creates a new Intune Role Definition.

```powershell
Configuration Example
{
    param(
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $credsGlobalAdmin
    )
    Import-DscResource -ModuleName Microsoft365DSC

    Node localhost
    {
        IntuneRoleDefinition "IntuneRoleDefinition"
        {
            allowedResourceActions    = @("Microsoft.Intune_Organization_Read","Microsoft.Intune_Roles_Create","Microsoft.Intune_Roles_Read","Microsoft.Intune_Roles_Update");
            Description               = "My role defined by me.";
            DisplayName               = "This is my role";
            Ensure                    = "Present";
            Id                        = "";
            IsBuiltIn                 = $False;
            notallowedResourceActions = @();
            roleScopeTagIds           = @("0","1");
            Credential                = $credsGlobalAdmin
        }
    }
}
```

