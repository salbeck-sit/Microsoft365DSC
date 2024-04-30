function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $IsEnabled,

        [Parameter()]
        [System.String[]]
        $OnlyTrialsWithoutPaymentMethod,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $OfferTypes,

        [Parameter()]
        [ValidateSet('Present')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message 'Getting configuration for Azure AD Self Service Purchase'
    $ConnectionMode = New-M365DSCConnection -Workload 'MSCommerce' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullReturn = $PSBoundParameters

    $msCommerceToken = @{Token = $Global:MSCloudLoginConnectionProfile.MSCommerce.AccessTokens[0]}

    try
    {
        $defaults = Get-MSCommercePolicy -PolicyId AllowSelfServicePurchase @msCommerceToken

        $onlyTrialsWithoutPaymentMethod = Get-MSCommerceProductPolicies -PolicyId AllowSelfServicePurchase @msCommerceToken | Where-Object -FilterScript {$_.PolicyValue -eq 'OnlyTrialsWithoutPaymentMethod'} | Select-Object -ExpandProperty ProductName

        $offerTypes = Get-MSCommerceProductPolicies -PolicyId AllowSelfServicePurchase -Scope OfferType @msCommerceToken |
            Select-Object -Property @{Label = 'OfferType';Expression={$_.Scope}}, @{Label='IsEnabled';Expression={$_.ScopeValue -eq 'Enabled'}}

        $result = @{
            IsSingleInstance               = 'Yes'
            IsEnabled                      = $defaults.DefaultValue -eq 'True'
            OnlyTrialsWithoutPaymentMethod = $onlyTrialsWithoutPaymentMethod
            OfferTypes                     = $offerTypes
            ApplicationId                  = $ApplicationId
            TenantId                       = $TenantId
            ApplicationSecret              = $ApplicationSecret
            CertificateThumbprint          = $CertificateThumbprint
            Managedidentity                = $ManagedIdentity.IsPresent
            Credential                     = $Credential
            AccessTokens                   = $AccessTokens
        }

        Write-Verbose -Message "Get-TargetResource Result: `n $(Convert-M365DscHashtableToString -Hashtable $result)"
        return $result
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullReturn
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter()]
        [System.Boolean]
        $IsEnabled,

        [Parameter()]
        [System.String[]]
        $OnlyTrialsWithoutPaymentMethod,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $OfferTypes,

        [Parameter()]
        [ValidateSet('Present')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    Write-Verbose -Message 'Setting configuration for Azure AD Security Defaults'
    $CurrentValues = Get-TargetResource @PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $msCommerceToken = @{Token = $Global:MSCloudLoginConnectionProfile.MSCommerce.AccessTokens[0]}

    Update-MSCommerceProductPolicy -PolicyId AllowSelfServicePurchase -Enabled $IsEnabled @msCommerceToken

    foreach ($productName in $OnlyTrialsWithoutPaymentMethod)
    {
        $productPolicy = Get-MSCommerceProductPolicies -PolicyId AllowedSelfServicePurchase @msCommerceToken | Where-Object -FilterScript {$_.ProductName -eq $productName}
        Update-MSCommerceProductPolicy -PolicyId AllowSelfServicePurchase -ProductId $productPolicy.ProductId @msCommerceToken
    }

    if ($OfferTypes.Count -gt 0)
    {
        $offerTypeList = Get-MSCommerceProductPolicy -PolicyId AllowSelfServicePurchase -Scope OfferType @msCommerceToken
        foreach ($offerType in $OfferTypes)
        {
            if ($offerType.OfferType -eq 'All')
            {
                foreach ($scope in $offerTypeList)
                {
                    if ($offerType.IsEnabled -ne (Get-MSCommerceProductPolicy -PolicyId AllowSelfServicePurchase -OfferType $scope).ScopeValue)
                    {
                        Update-MSCommerceProductPolicy -PolicyId AllowSelfServicePurchase -OfferType $scope -Enabled $offerType.IsEnabled @msCommerceToken
                    }
                }
            }
            else
            {
                $offerTypeId = $offerTypeList | Where-Object -FilterScript {$_.Scope -eq $OfferType.OfferType -or $_.ScopeId -eq $OfferType.OfferType} | Select-Object -ExpandProperty ScopeId
                if ($offerType.IsEnabled -ne (Get-MSCommerceProductPolicy -PolicyId AllowSelfServicePurchase -OfferType $scope).ScopeValue)
                {
                    Update-MSCommerceProductPolicy -PolicyId AllowSelfServicePurchase -OfferType $offerTypeId -Enabled $offerType.IsEnabled @msCommerceToken
                }
            }
        }
    }

}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [System.String]
        [ValidateSet('Yes')]
        $IsSingleInstance,

        [Parameter()]
        [ValidateSet('Enabled', 'Disabled')]
        [System.String]
        $SelfService,

        [Parameter()]
        [System.String[]]
        $OnlyTrialsWithoutPaymentMethod,

        [Parameter()]
        [Microsoft.Management.Infrastructure.CimInstance[]]
        $OfferTypeSelfService,

        [Parameter()]
        [ValidateSet('Present')]
        [System.String]
        $Ensure = 'Present',

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message 'Testing configuration of the Azure AD Security Defaults'

    $CurrentValues = Get-TargetResource @PSBoundParameters

    Write-Verbose -Message "Current Values: $(Convert-M365DscHashtableToString -Hashtable $CurrentValues)"
    Write-Verbose -Message "Target Values: $(Convert-M365DscHashtableToString -Hashtable $PSBoundParameters)"

    $ValuesToCheck = $PSBoundParameters

    $TestResult = Test-M365DSCParameterState -CurrentValues $CurrentValues `
        -Source $($MyInvocation.MyCommand.Source) `
        -DesiredValues $PSBoundParameters `
        -ValuesToCheck $ValuesToCheck.Keys

    Write-Verbose -Message "Test-TargetResource returned $TestResult"

    return $TestResult
}

function Export-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.String])]
    param
    (
        [Parameter()]
        [System.Management.Automation.PSCredential]
        $Credential,

        [Parameter()]
        [System.String]
        $ApplicationId,

        [Parameter()]
        [System.String]
        $TenantId,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret,

        [Parameter()]
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [Switch]
        $ManagedIdentity,

        [Parameter()]
        [System.String[]]
        $AccessTokens
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'MicrosoftGraph' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName -replace 'MSFT_', ''
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        $Params = @{
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            Managedidentity       = $ManagedIdentity.IsPresent
            IsSingleInstance      = 'Yes'
            ApplicationSecret     = $ApplicationSecret
            Credential            = $Credential
            AccessTokens          = $AccessTokens
        }
        $dscContent = ''
        $Results = Get-TargetResource @Params
        $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
            -Results $Results
        $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
            -ConnectionMode $ConnectionMode `
            -ModulePath $PSScriptRoot `
            -Results $Results `
            -Credential $Credential
        $dscContent += $currentDSCBlock
        Save-M365DSCPartialExport -Content $currentDSCBlock `
            -FileName $Global:PartialExportFileName
        Write-Host $Global:M365DSCEmojiGreenCheckMark
        return $dscContent
    }
    catch
    {
        Write-Host $Global:M365DSCEmojiRedX

        New-M365DSCLogEntry -Message 'Error during Export:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return ''
    }
}

Export-ModuleMember -Function *-TargetResource
