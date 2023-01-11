function createDigest ($message)
    {
            [OutputType([String])]  $stringAsStream = [System.IO.MemoryStream]::new()
            $writer = [System.IO.StreamWriter]::new($stringAsStream)
            $messageStripped = $message -replace "`r|`n",""
            $writer.write("$messageStripped")
            $writer.flush()
            $stringAsStream.Position = 0
            $digest = (Get-FileHash -InputStream $stringAsStream -Algorithm SHA256 | Select-Object Hash | Format-Table -HideTableHeaders | Out-String).Trim()
            return $digest
    }

$agentid = "47"
$organizationID = "4e"

$password = createDigest "${agentID}:$organizationID"
$pair = "$($agentID):$($password)"
$encodedCredentials = [System.Convert]::ToBase64String([System.Text.Encoding]::ASCII.GetBytes($pair))
$url = "https://api.threatsimulator.cloud/agent/auth?AgentID=$agentid&OrganizationID=$organizationId&RequestsOnly=true"
$headers = @{ Authorization = "Basic $encodedCredentials" }

wget -Uri "$url" -Headers $headers -OutFile "response.json"
