param(
  [string]$Path = "."
)

$root = Resolve-Path -LiteralPath $Path

function Test-File($name) {
  Test-Path -LiteralPath (Join-Path $root $name)
}

$result = [ordered]@{
  root = $root.Path
  git = Test-Path -LiteralPath (Join-Path $root ".git")
  node = Test-File "package.json"
  pnpm = Test-File "pnpm-lock.yaml"
  yarn = Test-File "yarn.lock"
  maven = Test-File "pom.xml"
  gradle = (Test-File "build.gradle") -or (Test-File "build.gradle.kts")
  python = (Test-File "requirements.txt") -or (Test-File "pyproject.toml")
  docker = (Test-File "Dockerfile") -or (Test-File "compose.yaml") -or (Test-File "docker-compose.yml")
  envExample = Test-File ".env.example"
  sourceDirs = @(@("src", "test", "tests") | Where-Object { Test-Path -LiteralPath (Join-Path $root $_) })
}

if ($result.node) {
  try {
    $pkg = Get-Content -Raw -LiteralPath (Join-Path $root "package.json") | ConvertFrom-Json
    $deps = @{}
    foreach ($section in @("dependencies", "devDependencies")) {
      if ($pkg.$section) {
        $pkg.$section.PSObject.Properties | ForEach-Object { $deps[$_.Name] = $_.Value }
      }
    }
    $result.frontend = [ordered]@{
      vue = $deps.ContainsKey("vue")
      react = $deps.ContainsKey("react")
      vite = $deps.ContainsKey("vite")
    }
  } catch {
    $result.packageJsonParseError = $_.Exception.Message
  }
}

$result | ConvertTo-Json -Depth 8
