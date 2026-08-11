param(
  [string]$Output = "build-and-ship-report.json",
  [string]$Status = "PARTIALLY_VERIFIED",
  [string[]]$Notes = @()
)

$report = [ordered]@{
  generatedAt = (Get-Date).ToString("o")
  status = $Status
  notes = $Notes
  environment = $null
  project = $null
}

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

try {
  $envJson = & (Join-Path $scriptDir "detect_environment.ps1")
  $report.environment = $envJson | ConvertFrom-Json
} catch {
  $report.environmentError = $_.Exception.Message
}

try {
  $projectJson = & (Join-Path $scriptDir "detect_project.ps1")
  $report.project = $projectJson | ConvertFrom-Json
} catch {
  $report.projectError = $_.Exception.Message
}

$report | ConvertTo-Json -Depth 10 | Set-Content -LiteralPath $Output -Encoding UTF8
Write-Output $Output
