#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
LAB_CONTEXT="$(kubectl config current-context)"
case "$LAB_CONTEXT" in kind-susu-argo-lab|kind-susu-flux-lab) ;; *) echo 'Select a named Susu practice cluster first.'; exit 1;; esac
kubectl apply -k k8s
kubectl rollout status deployment/susu-haven -n lab --timeout=180s
kubectl get deployment,replicaset,pods,service -n lab
