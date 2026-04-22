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
  Install-Release -Name 'istio-gravitatehealth' -Chart '../istio/charts/istio-gravitatehealth' -TargetNamespace $Namespace
  Install-Release -Name 'fhir-server-ips' -Chart '../fhir-ips/charts/hapi-fhir-jpaserver' -TargetNamespace $Namespace
  Install-Release -Name 'fhir-server-epi' -Chart '../fhir-epi/charts/hapi-fhir-jpaserver' -TargetNamespace $Namespace
  Install-Release -Name 'terminology-service' -Chart '../terminology-service/charts/terminology-service' -TargetNamespace $Namespace
  Install-Release -Name 'keycloak' -Chart '../keycloak/charts/keycloak' -TargetNamespace $Namespace
  Install-Release -Name 'keycloak-registration' -Chart '../keycloak-registration/charts/keycloak-registration' -TargetNamespace $Namespace
  Install-Release -Name 'fhir-connector' -Chart '../fhir-connector/charts/fhir-connector' -TargetNamespace $Namespace
  Install-Release -Name 'focusing-manager' -Chart '../focusing-manager/charts/focusing-manager' -TargetNamespace $Namespace
}

Write-Host 'Plain Helm fallback currently supports the core profile path only.'
Write-Host 'Use Helmfile for AI, observability, all profiles, and shared-host propagation overlays.'
