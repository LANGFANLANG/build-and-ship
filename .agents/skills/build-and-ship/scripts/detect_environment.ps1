param(
  [string[]]$Ports = @()
)

function Get-CommandVersion {
  param(
    [string]$Name,
    [string[]]$VersionArgs = @("--version")
  )

  $cmd = Get-Command $Name -ErrorAction SilentlyContinue
  if (-not $cmd) {
    return [ordered]@{
      installed = $false
      path = $null
      version = $null
    }
  }

  $version = $null
  try {
    $version = (& $Name @VersionArgs 2>&1 | Select-Object -First 1).ToString()
  } catch {
    $version = "installed, version check failed"
  }

  [ordered]@{
    installed = $true
    path = $cmd.Source
    version = $version
  }
}

$normalizedPorts = @()
foreach ($portValue in $Ports) {
  $normalizedPorts += ($portValue -split "," | ForEach-Object { $_.Trim() } | Where-Object { $_ })
}

$portResults = @{}
foreach ($port in $normalizedPorts) {
  $listeners = @(Get-NetTCPConnection -LocalPort ([int]$port) -State Listen -ErrorAction SilentlyContinue)
  $portResults[$port] = [ordered]@{
    available = $listeners.Count -eq 0
    listeners = @($listeners | Where-Object { $_ } | ForEach-Object {
      [ordered]@{
        localAddress = $_.LocalAddress
        localPort = $_.LocalPort
        processId = $_.OwningProcess
      }
    })
  }
}

$result = [ordered]@{
  os = [System.Environment]::OSVersion.VersionString
  git = Get-CommandVersion "git"
  node = Get-CommandVersion "node"
  npm = Get-CommandVersion "npm"
  pnpm = Get-CommandVersion "pnpm"
  java = Get-CommandVersion "java" @("-version")
  maven = Get-CommandVersion "mvn" @("-version")
  gradle = Get-CommandVersion "gradle" @("-version")
  python = Get-CommandVersion "python"
  py = Get-CommandVersion "py"
  docker = Get-CommandVersion "docker"
  ports = $portResults
}

$result | ConvertTo-Json -Depth 8
