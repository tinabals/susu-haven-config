#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/common.sh
require_lab
if k -n argocd get application "$LAB_APP" >/dev/null 2>&1; then
  printf '%s\n' 'An Argo Application already exists. Deploy through Git and Sync instead; see the existing-lab path in SETUP.md.' >&2
  exit 1
fi
k apply -k k8s
k -n "$LAB_NAMESPACE" rollout status deployment/"$LAB_APP" --timeout=180s
k -n "$LAB_NAMESPACE" get deployment,replicaset,pods,service
