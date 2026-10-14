#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/common.sh
require_lab
LAB_REPO_URL="${1:-}"
if [[ ! "$LAB_REPO_URL" =~ ^https://github\.com/[A-Za-z0-9_.-]+/[A-Za-z0-9_.-]+$ ]] || [[ "$LAB_REPO_URL" == *YOUR_USERNAME* ]]; then
  printf '%s\n' 'Usage: bash scripts/06-connect-source.sh https://github.com/ACTUAL_OWNER/ACTUAL_REPO.git' 'Use a public practice repository with no URL credentials.' >&2
  exit 1
fi
if k -n argocd get application "$LAB_APP" >/dev/null 2>&1; then
  printf '%s\n' 'Application already exists. Keeping its repository settings. Use the existing-lab path in SETUP.md.' >&2
  exit 1
fi
sed "s|REPLACE_WITH_PUBLIC_REPO_URL|$LAB_REPO_URL|" gitops/argocd-application.yaml | k apply -f -
printf '%s\n' 'Application created in manual-sync mode. Open Argo CD, inspect the source and click Sync.'
