# gke-retail-devops

Helm chart + scripts to put GAR images onto GKE Autopilot.

```bash
# no cluster — YAML only
./scripts/validate-helm.sh dev
./scripts/helm-deploy.sh dev --dry-run

# cluster (after: gcloud container clusters get-credentials retail-dev ...)
# DB-backed services need Secret Manager → K8s secret first:
./scripts/sync-db-secret.sh dev
./scripts/helm-deploy.sh dev
kubectl -n retail-dev get pods -w
```

First deploy uses `helm/retail-platform/services.live-12.yaml` (12 images that already exist).
DB services connect to Cloud SQL over **private VPC IP** (`global.cloudSql.privateIp`) with Secret `retail-db`.
Optional Auth Proxy sidecar: set `enableCloudSqlProxy: true` (needs Workload Identity).
BFF has no DB.
