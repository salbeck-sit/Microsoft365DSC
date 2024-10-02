<#
This example removes a Device Control Policy.
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
        IntuneFirewallPolicyWindows10 'ConfigureIntuneFirewallPolicyWindows10'
        {
            Id          = '00000000-0000-0000-0000-000000000000'
            DisplayName = 'Intune Firewall Policy Windows10'
            Ensure      = 'Absent'
            ApplicationId         = $ApplicationId;
            TenantId              = $TenantId;
            CertificateThumbprint = $CertificateThumbprint;
        }
    }
}
