param(
  [Parameter(Mandatory = $true)]
  [string]$Url,
  [int]$TimeoutSeconds = 60,
  [int]$IntervalSeconds = 2
)

$deadline = (Get-Date).AddSeconds($TimeoutSeconds)
$lastError = $null

while ((Get-Date) -lt $deadline) {
  try {
    $response = Invoke-WebRequest -Uri $Url -UseBasicParsing -TimeoutSec $IntervalSeconds
    if ($response.StatusCode -ge 200 -and $response.StatusCode -lt 500) {
      [ordered]@{
        status = "PASS"
        url = $Url
        statusCode = $response.StatusCode
      } | ConvertTo-Json
      exit 0
    }
  } catch {
    $lastError = $_.Exception.Message
  }
  Start-Sleep -Seconds $IntervalSeconds
}

[ordered]@{
  status = "FAIL"
  url = $Url
  error = $lastError
} | ConvertTo-Json
exit 1
