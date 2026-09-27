#!/usr/bin/env bash
# Lint + template the live 12-service chart (no cluster required).
set -euo pipefail

ENV="${1:-dev}"
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CHART="${ROOT}/helm/retail-platform"
VALUES="${CHART}/values-${ENV}.yaml"
SERVICES="${SERVICES_FILE:-${CHART}/services.live-12.yaml}"

[[ -f "${VALUES}" ]] || { echo "Missing ${VALUES}"; exit 1; }
[[ -f "${SERVICES}" ]] || { echo "Missing ${SERVICES}"; exit 1; }

helm lint "${CHART}" \
  -f "${CHART}/values.yaml" \
  -f "${VALUES}" \
  -f "${SERVICES}"

helm template "retail-${ENV}-ci" "${CHART}" \
  -f "${CHART}/values.yaml" \
  -f "${VALUES}" \
  -f "${SERVICES}" \
  >/dev/null

echo "DevOps Helm validation passed (${ENV}, $(basename "${SERVICES}"))."
