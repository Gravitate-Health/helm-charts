# Gravitate Health Platform Installer (Helmfile)

This repository orchestrates the deployment of the Gravitate Health platform charts across the mono-workspace.

## Prerequisites

- Kubernetes cluster access configured in your kubeconfig
- [Helm 3](https://helm.sh/docs/intro/install/) installed on the control machine
- [Helmfile](https://helmfile.readthedocs.io/en/latest/#installation) installed on the control machine
- [Istio installer CLI](https://istio.io/latest/docs/ops/diagnostic-tools/istioctl/) (`istioctl`) installed on the control machine when `modules.istio=true` (default profiles)
- Access to private image registry (if required by your environment)

## Layout

- `helmfile.yaml`: root orchestrator for all modules
- `environments/`: global defaults and install profile inputs
- `values/releases/`: per-module overlays used to propagate shared values (like host)
- `scripts/`: helper commands for helmfile and optional plain Helm fallback

## Quick Start

Only one value is expected to change for most deployments: `global.host`.

### Core profile

```bash
helmfile -f helmfile.yaml -e quickstart --state-values-set global.host=fosps.example.org apply
```

### AI profile

```bash
helmfile -f helmfile.yaml -e quickstart-ai --state-values-set global.host=fosps.example.org apply
```

### Observability profile

```bash
helmfile -f helmfile.yaml -e quickstart-observability --state-values-set global.host=fosps.example.org apply
```

### All modules

```bash
helmfile -f helmfile.yaml -e quickstart-all --state-values-set global.host=fosps.example.org apply
```

## Full Install

Full install enables all modules by default and supports namespace customization.

```bash
helmfile -f helmfile.yaml -e full \
  --state-values-set global.host=fosps.example.org \
  --state-values-set global.namespace=gravitate \
  --state-values-set global.monitoringNamespace=monitoring \
  apply
```

## Optional Plain Helm Fallback

A lightweight plain Helm script is available for the core path:

```bash
bash scripts/install-helm.sh quickstart
```

PowerShell variant:

```powershell
pwsh ./scripts/install-helm.ps1 -Profile quickstart -Namespace default
```

For full profile orchestration and dynamic value propagation, use Helmfile.

## Notes

- `global.host` is propagated to gateway/certificate and selected module public URLs via release overlays.
- Some charts have module-specific networking keys and may require additional tuning in their own values.
- If Istio is disabled, any module that expects Istio VirtualService/Gateway may require ingress or `networking.type=none` adjustments.
