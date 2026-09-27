# gke-retail-devops

Helm chart + scripts to put GAR images onto GKE Autopilot.

```bash
# no cluster — YAML only
./scripts/validate-helm.sh dev
./scripts/helm-deploy.sh dev --dry-run

# cluster (after: gcloud container clusters get-credentials retail-dev ...)
./scripts/helm-deploy.sh dev
kubectl -n retail-dev get pods -w
```

First deploy uses `helm/retail-platform/services.live-12.yaml` (12 images that already exist). Do not use `services.generated.yaml` until those images are in GAR.
