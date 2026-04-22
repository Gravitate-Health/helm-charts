#!/usr/bin/env bash
set -euo pipefail

PROFILE="${1:-quickstart}"
HOST_NAME="${2:-}"
NAMESPACE="${3:-}"
DRY_RUN="${4:-false}"

run_release() {
  local release_name="$1"
  local chart_path="$2"
  local namespace="$3"

  echo "Installing ${release_name} from ${chart_path} into namespace ${namespace}"
  helm upgrade --install "${release_name}" "${chart_path}" --namespace "${namespace}" --create-namespace
}

if [[ "${PROFILE}" == "quickstart" || "${PROFILE}" == "core" ]]; then
  TARGET_NAMESPACE="${NAMESPACE:-default}"
  run_release "istio-gravitatehealth" "../istio/charts/istio-gravitatehealth" "${TARGET_NAMESPACE}"
  run_release "fhir-server-ips" "../fhir-ips/charts/hapi-fhir-jpaserver" "${TARGET_NAMESPACE}"
  run_release "fhir-server-epi" "../fhir-epi/charts/hapi-fhir-jpaserver" "${TARGET_NAMESPACE}"
  run_release "terminology-service" "../terminology-service/charts/terminology-service" "${TARGET_NAMESPACE}"
  run_release "keycloak" "../keycloak/charts/keycloak" "${TARGET_NAMESPACE}"
  run_release "keycloak-registration" "../keycloak-registration/charts/keycloak-registration" "${TARGET_NAMESPACE}"
  run_release "fhir-connector" "../fhir-connector/charts/fhir-connector" "${TARGET_NAMESPACE}"
  run_release "focusing-manager" "../focusing-manager/charts/focusing-manager" "${TARGET_NAMESPACE}"
fi

echo "Note: Helm fallback script currently supports the core profile path only."
echo "For AI/observability/all profiles and dynamic host propagation, use scripts/install-helmfile.ps1 or helmfile directly."
