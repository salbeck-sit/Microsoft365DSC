function Get-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('SendAs')]
        [System.String]
        $AccessRights,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Trustee,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure,

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
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret
    )

    New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters | Out-Null

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $nullResult = $PSBoundParameters
    $nullResult.Ensure = 'Absent'
    try
    {
        $instance = Get-RecipientPermission -Identity $Identity -Trustee $Trustee -AccessRights $AccessRights -ErrorAction SilentlyContinue
        if ($null -eq $instance)
        {
            return $nullResult
        }
        $identityObj = Get-Mailbox -Identity $instance.Identity -ErrorAction SilentlyContinue
        if (-not $identityObj)
        {
            $identityObj = Get-MailUser -Identity $instance.Identity -ErrorAction SilentlyContinue
            if (-not $identityObj)
            {
                $identityObj = Get-MailContact -Identity $instance.Identity -ErrorAction SilentlyContinue
            }
        }
        if ($identityObj)
        {
            $displayIdentity = $identityObj.WindowsEmailAddress
        }
        else
        {
            $identityObj = Get-DistributionGroup -Identity $instance.Identity -ErrorAction SilentlyContinue
            if (-not $identityObj)
            {
                $identityObj = Get-DynamicDistributionGroup -Identity $instance.Identity -ErrorAction SilentlyContinue
            }
            if ($identityObj)
            {
                $displayIdentity = $identityObj.DisplayName
            }
        }
        if (-not $displayIdentity)
        {
            $displayIdentity = $instance.Identity
        }
        if ($instance.Trustee -match '@')
        {
            $displayTrustee = $instance.Trustee
        }
        else
        {
            # Note. I can't get securitygroups from Get-Group or Get-SecurityPrincipal even though Docs says I can.
            # Could this be a permissions-issue ? The below workaround seems clumsy
            if (-not $script:allGroups)
            {
                if (-not $Global:MSCloudLoginConnectionProfile.MicrosoftGraph.Connected)
                {
                    New-M365DSCConnection -Workload 'MicrosoftGraph' `
                        -InboundParameters $PSBoundParameters | Out-Null
                }
                [array]$script:allGroups = Get-MgGroup -All -Property 'DisplayName', 'SecurityIdentifier'
            }
            $trusteeObj = $script:allGroups | Where-Object -FilterScript {$_.SecurityIdentifier -eq '$($instance.TrusteeSidString)'}
            if ($null -ne $trusteeObj)
            {
                $displayTrustee = $trusteeObj.DisplayName
            }
        }

        Write-Verbose -Message "Found an instance with Identity {$Identity} and Trustee {$Trustee}"
        $results = @{
            AccessRights          = $instance.AccessRights -join ','
            Identity              = $displayIdentity
            Trustee               = $displayTrustee
            Ensure                = 'Present'
            Credential            = $Credential
            ApplicationId         = $ApplicationId
            TenantId              = $TenantId
            CertificateThumbprint = $CertificateThumbprint
            ApplicationSecret     = $ApplicationSecret
        }
        return [System.Collections.Hashtable] $results
    }
    catch
    {
        New-M365DSCLogEntry -Message 'Error retrieving data:' `
            -Exception $_ `
            -Source $($MyInvocation.MyCommand.Source) `
            -TenantId $TenantId `
            -Credential $Credential

        return $nullResult
    }
}

function Set-TargetResource
{
    [CmdletBinding()]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('SendAs')]
        [System.String]
        $AccessRights,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Trustee,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure,

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
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret
    )

    New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters | Out-Null

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    $currentInstance = Get-TargetResource @PSBoundParameters

    $BoundParameters = Remove-M365DSCAuthenticationParameter -BoundParameters $PSBoundParameters

    if ($Ensure -eq 'Present' -and $currentInstance.Ensure -eq 'Absent')
    {
        $CreateParameters = ([Hashtable]$BoundParameters).Clone()

        $CreateParameters.Remove('Verbose') | Out-Null

        Write-Verbose -Message "Creating {$Identity} with Parameters:`r`n$(Convert-M365DscHashtableToString -Hashtable $CreateParameters)"
        try {
            Add-RecipientPermission @CreateParameters -Confirm:$false -ErrorAction Stop | Out-Null
        }
        catch {
            $errorMessage = "Error adding recipientpermission for Identity=$Identity and Trustee=$Trustee, $($_.Exception.Message)"
            Add-M365DSCEvent -Message $errorMessage `
                -EntryType 'Error' `
                -EventID 1 `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId
            throw $errorMessage # stop applying config if values can't be changed
        }
    }
    elseif ($Ensure -eq 'Absent' -and $currentInstance.Ensure -eq 'Present')
    {
        Write-Verbose -Message "Removing existing {$Identity}/{$Trustee}"
        try {
            Remove-RecipientPermission -Identity $currentInstance.Identity -AccessRights $AccessRights -Trustee $Trustee -Confirm:$false -SkipDomainValidationForMailContact -SkipDomainValidationForMailUser -SkipDomainValidationForSharedMailbox -ErrorAction Stop
        }
        catch {
            $errorMessage = "Error removing recipientpermission for Identity=$Identity and Trustee=$Trustee, $($_.Exception.Message)"
            Add-M365DSCEvent -Message $errorMessage `
                -EntryType 'Error' `
                -EventID 2 `
                -Source $($MyInvocation.MyCommand.Source) `
                -TenantId $TenantId
            throw $errorMessage # stop applying config if values can't be changed
        }
    }
    else
    {
        Write-Verbose -Message "RecipientPermission match for Identity $Identity and Trustee $Trustee, no update required"
    }
}

function Test-TargetResource
{
    [CmdletBinding()]
    [OutputType([System.Boolean])]
    param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet('SendAs')]
        [System.String]
        $AccessRights,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Identity,

        [Parameter(Mandatory = $true)]
        [System.String]
        $Trustee,

        [Parameter()]
        [ValidateSet('Present', 'Absent')]
        [System.String]
        $Ensure,

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
        [System.String]
        $CertificateThumbprint,

        [Parameter()]
        [System.Management.Automation.PSCredential]
        $ApplicationSecret
    )

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    Write-Verbose -Message "Testing configuration of {$Identity}"

    $CurrentValues = Get-TargetResource @PSBoundParameters

    if ($Ensure -eq $CurrentValues.Ensure)
    {
        $returnResult = $true
    }
    else
    {
        $returnResult = $false
    }
    Write-Verbose -Message "Test-TargetResource returned $returnResult (Ensure=$Ensure)"
    return $returnResult
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
        $ManagedIdentity
    )

    $ConnectionMode = New-M365DSCConnection -Workload 'ExchangeOnline' `
        -InboundParameters $PSBoundParameters

    #Ensure the proper dependencies are installed in the current environment.
    Confirm-M365DSCDependencies

    #region Telemetry
    $ResourceName = $MyInvocation.MyCommand.ModuleName.Replace('MSFT_', '')
    $CommandName = $MyInvocation.MyCommand
    $data = Format-M365DSCTelemetryParameters -ResourceName $ResourceName `
        -CommandName $CommandName `
        -Parameters $PSBoundParameters
    Add-M365DSCTelemetryEvent -Data $data
    #endregion

    try
    {
        [array]$getValue = Get-RecipientPermission -ResultSize Unlimited -ErrorAction Stop | Where-Object -FilterScript {$_.IsValid -eq $true -and $_.IsInherited -eq $false -and $_.Trustee -notin @('NT AUTHORITY\SELF', 'NULL SID')} | Group-Object -Property Identity

        $i = 1
        $dscContent = ''
        if ($getValue.Length -eq 0)
        {
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
        else
        {
            Write-Host "`r`n" -NoNewline
        }
        foreach ($config in $getValue)
        {
            Write-Host "    |---[$i/$($getValue.Count)] $displayedKey ($($configGroup.Count) trustees)" -NoNewline
            foreach ($configValue in $configGroup.Group)
            {
                $params = @{
                    AccessRights          = $configValue.AccessRights -join ','
                    Identity              = $configValue.Identity
                    Trustee               = $configValue.Trustee
                    Ensure                = 'Present'
                    Credential            = $Credential
                    ApplicationId         = $ApplicationId
                    TenantId              = $TenantId
                    CertificateThumbprint = $CertificateThumbprint
                    ApplicationSecret     = $ApplicationSecret
                }
                $Results = Get-TargetResource @Params

                $Results = Update-M365DSCExportAuthenticationResults -ConnectionMode $ConnectionMode `
                    -Results $params

                $currentDSCBlock = Get-M365DSCExportContentForResource -ResourceName $ResourceName `
                    -ConnectionMode $ConnectionMode `
                    -ModulePath $PSScriptRoot `
                    -Results $Results `
                    -Credential $Credential
                $dscContent += $currentDSCBlock
                Save-M365DSCPartialExport -Content $currentDSCBlock `
                    -FileName $Global:PartialExportFileName
            }
            $i++
            Write-Host $Global:M365DSCEmojiGreenCheckMark
        }
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
