#!/usr/bin/env bash
# Deploy the 12 live services to GKE.
# Usage:
#   ./scripts/helm-deploy.sh dev
#   ./scripts/helm-deploy.sh dev --dry-run
#   IMAGE_TAG=develop-d81e4327 ./scripts/helm-deploy.sh dev
set -euo pipefail

ENV="${1:?Usage: helm-deploy.sh <dev|qa|test|prod> [--dry-run]}"
DRY_RUN=""
[[ "${2:-}" == "--dry-run" ]] && DRY_RUN="--dry-run"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CHART="${ROOT}/helm/retail-platform"
VALUES_ENV="${CHART}/values-${ENV}.yaml"
SERVICES="${SERVICES_FILE:-${CHART}/services.live-12.yaml}"
NAMESPACE="retail-${ENV}"

[[ -f "${VALUES_ENV}" ]] || { echo "Missing ${VALUES_ENV}"; exit 1; }
[[ -f "${SERVICES}" ]] || { echo "Missing ${SERVICES}"; exit 1; }

EXTRA=()
if [[ -n "${IMAGE_TAG:-}" ]]; then
  EXTRA+=(--set "global.imageTag=${IMAGE_TAG}")
fi

echo "Release    retail-${ENV}"
echo "Namespace  ${NAMESPACE}"
echo "Services   ${SERVICES}"
echo "Values     ${VALUES_ENV}"

helm upgrade --install "retail-${ENV}" "${CHART}" \
  --namespace "${NAMESPACE}" \
  --create-namespace \
  -f "${CHART}/values.yaml" \
  -f "${VALUES_ENV}" \
  -f "${SERVICES}" \
  ${EXTRA[@]+"${EXTRA[@]}"} \
  ${DRY_RUN} \
  --timeout 15m

if [[ -z "${DRY_RUN}" ]]; then
  echo ""
  echo "Watch pods (Autopilot nodes take 2–5 min):"
  echo "  kubectl -n ${NAMESPACE} get pods -w"
fi
