<#
This example is used to test new resources and showcase the usage of new resources being worked on.
It is not meant to use as a production baseline.
#>

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
        EXOMailboxIRMAccess "EXOMailboxIRMAccess-qwe@testorg.onmicrosoft.com"
        {
            AccessLevel            = "Block";
            ApplicationId          = $ApplicationId
            TenantId               = $TenantId
            CertificateThumbprint  = $CertificateThumbprint
            Ensure                 = "Present";
            Identity               = "qwe@$OrganizationName";
            User                   = "admin@$OrganizationName";
        }
    }
}
