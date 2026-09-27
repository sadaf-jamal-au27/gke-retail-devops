#!/usr/bin/env bash
# Sync Cloud SQL app password from Secret Manager → K8s secret retail-db (key: password).
# Usage: ./scripts/sync-db-secret.sh [dev|qa|test|prod]
set -euo pipefail

ENV="${1:-dev}"
NS="retail-${ENV}"
PROJECT="${GCP_PROJECT_ID:-ai-rag-agent-project}"
SM_SECRET="${DB_PASSWORD_SECRET:-retail-db-password}"

TMP="$(mktemp)"
trap 'rm -f "${TMP}"' EXIT

echo "Namespace  ${NS}"
echo "SM secret  ${SM_SECRET} → k8s secret/retail-db"

gcloud secrets versions access latest \
  --secret="${SM_SECRET}" \
  --project="${PROJECT}" > "${TMP}"

kubectl -n "${NS}" create secret generic retail-db \
  --from-file=password="${TMP}" \
  --dry-run=client -o yaml | kubectl apply -f -

echo "Done. Verify: kubectl -n ${NS} get secret retail-db"
