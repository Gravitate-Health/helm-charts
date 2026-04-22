param(
  [ValidateSet('quickstart', 'quickstart-ai', 'quickstart-observability', 'quickstart-all', 'full')]
  [string]$Environment = 'quickstart',
  [string]$HostName = '',
  [string]$Namespace = '',
  [switch]$DryRun
)

$ErrorActionPreference = 'Stop'

$args = @('-f', 'helmfile.yaml', '-e', $Environment)

if ($HostName -ne '') {
  $args += @('--state-values-set', "global.host=$HostName")
}

if ($Namespace -ne '') {
  $args += @('--state-values-set', "global.namespace=$Namespace")
}

if ($DryRun) {
  $args += 'template'
} else {
  $args += 'apply'
}

Write-Host "Running: helmfile $($args -join ' ')"
& helmfile @args
