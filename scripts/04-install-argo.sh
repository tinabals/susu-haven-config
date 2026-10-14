#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/common.sh
require_lab
if k -n argocd get deployment argocd-server >/dev/null 2>&1; then
  printf '%s\n' 'Argo CD is already installed. Keeping the existing installation.'
  k -n argocd get pods
  exit 0
fi
k create namespace argocd --dry-run=client -o yaml | k apply -f -
k apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
printf '%s\n' 'Installation submitted. Images may take time to download.'
k -n argocd rollout status deployment/argocd-server --timeout=300s
k -n argocd get pods
