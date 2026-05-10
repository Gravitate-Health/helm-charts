param(
  [ValidateSet('quickstart', 'core')]
  [string]$Profile = 'quickstart',
  [string]$Namespace = 'default'
)

$ErrorActionPreference = 'Stop'

function Install-Release {
  param(
    [string]$Name,
    [string]$Chart,
    [string]$TargetNamespace
  )

  Write-Host "Installing $Name from $Chart into namespace $TargetNamespace"
  helm upgrade --install $Name $Chart --namespace $TargetNamespace --create-namespace
}

if ($Profile -in @('quickstart', 'core')) {
  Install-Release -Name 'istio-gravitatehealth' -Chart 'oci://ghcr.io/gravitate-health/charts/istio-gravitatehealth' -TargetNamespace $Namespace
  Install-Release -Name 'fhir-server-ips' -Chart 'oci://ghcr.io/gravitate-health/charts/fhir-ips' -TargetNamespace $Namespace
  Install-Release -Name 'fhir-server-epi' -Chart 'oci://ghcr.io/gravitate-health/charts/fhir-epi' -TargetNamespace $Namespace
  Install-Release -Name 'terminology-service' -Chart 'oci://ghcr.io/gravitate-health/charts/terminology-service' -TargetNamespace $Namespace
  Install-Release -Name 'keycloak' -Chart 'oci://ghcr.io/gravitate-health/charts/keycloak' -TargetNamespace $Namespace
  Install-Release -Name 'keycloak-registration' -Chart 'oci://ghcr.io/gravitate-health/charts/keycloak-registration' -TargetNamespace $Namespace
  Install-Release -Name 'fhir-connector' -Chart 'oci://ghcr.io/gravitate-health/charts/fhir-connector' -TargetNamespace $Namespace
  Install-Release -Name 'focusing-manager' -Chart 'oci://ghcr.io/gravitate-health/charts/focusing-manager' -TargetNamespace $Namespace
}

Write-Host 'Plain Helm fallback currently supports the core profile path only.'
Write-Host 'Use Helmfile for AI, observability, all profiles, and shared-host propagation overlays.'
