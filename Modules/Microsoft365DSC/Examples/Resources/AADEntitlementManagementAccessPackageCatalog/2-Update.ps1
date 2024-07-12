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
        AADEntitlementManagementAccessPackageCatalog 'myAccessPackageCatalog'
        {
            DisplayName         = 'My Catalog'
            CatalogStatus       = 'Published'
            CatalogType         = 'UserManaged'
            Description         = 'Built-in catalog.'
            IsExternallyVisible = $False # Updated Property
            Managedidentity     = $False
            Ensure              = 'Present'
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
