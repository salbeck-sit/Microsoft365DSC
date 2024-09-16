function Invoke-M365DSCAzureDevOPSWebRequest
{
    [OutputType([PSCustomObject])]
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true)]
        [System.String]
        $Uri,

        [Parameter()]
        [System.String]
        $Method = 'GET',

        [Parameter()]
        [System.Collections.Hashtable]
        $Body
    )

    $headers = @{
        Authorization = $global:MsCloudLoginConnectionProfile.AzureDevOPS.AccessToken
        'Content-Type' = 'application/json-patch+json'
    }

    $response = Invoke-WebRequest -Method $Method -Uri $Uri -Headers $headers -Body $Body
    $result = ConvertFrom-Json $response.Content
    return $result
}
