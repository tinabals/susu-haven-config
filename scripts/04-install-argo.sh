#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
test "$(kubectl config current-context)" = kind-susu-argo-lab || { echo 'Select kind-susu-argo-lab first.'; exit 1; }
kubectl create namespace argocd --dry-run=client -o yaml | kubectl apply -f -
kubectl apply -n argocd --server-side --force-conflicts -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
kubectl get pods -n argocd
printf '%s\n' 'Wait for readiness, then follow SETUP.md for login and source connection.'
