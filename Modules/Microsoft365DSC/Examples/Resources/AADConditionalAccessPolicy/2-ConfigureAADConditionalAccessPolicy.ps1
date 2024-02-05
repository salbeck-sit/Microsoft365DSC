<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

Configuration Example
{
    param
    (
        [Parameter(Mandatory = $true)]
        [PSCredential]
        $Credscredential
    )
    Import-DscResource -ModuleName Microsoft365DSC

    node localhost
    {
        AADConditionalAccessPolicy 'Allin-example'
        {
            Id                                   = '4b0bb08f-85ab-4a12-a12c-06114b6ac6df'
            DisplayName                          = 'Allin-example'
            BuiltInControls                      = @('Mfa', 'CompliantDevice', 'DomainJoinedDevice', 'ApprovedApplication', 'CompliantApplication')
            ClientAppTypes                       = @('ExchangeActiveSync', 'Browser', 'MobileAppsAndDesktopClients', 'Other')
            CloudAppSecurityIsEnabled            = $True
            CloudAppSecurityType                 = 'MonitorOnly'
            ExcludeApplications                  = @('Azure Media Service', 'Microsoft Rights Management Services', 'Dataverse', 'Office365', 'MicrosoftAdminPortals')
            ExcludeGroups                        = @()
            ExcludeLocations                     = @('Blocked Countries')
            ExcludePlatforms                     = @('Windows', 'WindowsPhone', 'MacOS')
            ExcludeRoles                         = @('Company Administrator', 'Application Administrator', 'Application Developer', 'Cloud Application Administrator', 'Cloud Device Administrator')
            ExcludeUsers                         = @('admin@contoso.com', 'AAdmin@contoso.com', 'CAAdmin@contoso.com', 'AllanD@contoso.com', 'AlexW@contoso.com', 'GuestsOrExternalUsers')
            ExcludeExternalTenantsMembers        = @()
            ExcludeExternalTenantsMembershipKind = 'all'
            ExcludeGuestOrExternalUserTypes      = @('internalGuest', 'b2bCollaborationMember')
            GrantControlOperator                 = 'OR'
            IncludeApplications                  = @('All')
            IncludeGroups                        = @()
            IncludeLocations                     = @('AllTrusted')
            IncludePlatforms                     = @('Android', 'IOS')
            IncludeRoles                         = @('Compliance Administrator')
            IncludeUserActions                   = @()
            IncludeUsers                         = @('Alexw@contoso.com')
            IncludeExternalTenantsMembers        = @('11111111-1111-1111-1111-111111111111')
            IncludeExternalTenantsMembershipKind = 'enumerated'
            IncludeGuestOrExternalUserTypes      = @('b2bCollaborationGuest')
            PersistentBrowserIsEnabled           = $false
            PersistentBrowserMode                = ''
            SignInFrequencyIsEnabled             = $true
            SignInFrequencyType                  = 'Hours'
            SignInFrequencyValue                 = 5
            SignInRiskLevels                     = @('High', 'Medium')
            State                                = 'disabled'
            UserRiskLevels                       = @('High', 'Medium')
            Ensure                               = 'Present'
            Credential                           = $Credscredential
        }
    }
}
