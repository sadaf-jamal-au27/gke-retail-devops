#!/usr/bin/env bash
set -euo pipefail
PROJECT_ID="${PROJECT_ID:?Set PROJECT_ID}"
REGION="${REGION:-asia-south1}"
REGISTRY="${REGION}-docker.pkg.dev/${PROJECT_ID}/retail"
APP_ROOT="${APPLICATION_ROOT:-$(cd "$(dirname "$0")/../../gke-retail-application" 2>/dev/null && pwd)}"
[[ -d "${APP_ROOT}/services" ]] || { echo "Set APPLICATION_ROOT to gke-retail-application clone"; exit 1; }
gcloud auth configure-docker "${REGION}-docker.pkg.dev" --quiet
cd "${APP_ROOT}"
pnpm install --no-frozen-lockfile
pnpm --filter @retail/service-core build
for dir in services/*/; do
  name="$(basename "$dir")"
  docker build -f "services/${name}/Dockerfile" -t "${REGISTRY}/${name}:1.0.0" .
  docker push "${REGISTRY}/${name}:1.0.0"
done
