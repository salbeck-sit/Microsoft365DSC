<#
This example removes a Device Remediation.
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
        IntuneAppAndBrowserIsolationPolicyWindows10 'ConfigureAppAndBrowserIsolationPolicyWindows10'
        {
            Id          = '00000000-0000-0000-0000-000000000000'
            DisplayName = 'App and Browser Isolation'
            Ensure      = 'Absent'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
