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
        EXOInboundConnector 'ConfigureInboundConnector'
        {
            Identity                     = "Integration Inbound Connector"
            CloudServicesMailEnabled     = $False
            Comment                      = "Inbound connector for Integration"
            ConnectorSource              = "Default"
            ConnectorType                = "Partner"
            Enabled                      = $True
            RequireTls                   = $True
            SenderDomains                = "*.contoso.com"
            TlsSenderCertificateName     = "contoso.com"
            Ensure                       = "Present"
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
        }
    }
}
