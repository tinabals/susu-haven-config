#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
LAB_TOOL="${1:-}"
LAB_REPO_URL="${2:-}"
case "$LAB_REPO_URL" in https://*) ;; *) echo 'Pass the public HTTPS clone URL as the second argument.'; exit 1;; esac
case "$LAB_REPO_URL" in *REPLACE*|*YOUR_USERNAME*) echo 'Replace the placeholder first.'; exit 1;; esac
# Print the generated manifest rather than saving repository credentials.
case "$LAB_TOOL" in
 argo)
  test "$(kubectl config current-context)" = kind-susu-argo-lab
  sed "s|REPLACE_WITH_PUBLIC_REPO_URL|$LAB_REPO_URL|" gitops/argocd-application.yaml | kubectl apply -f - ;;
 flux)
  test "$(kubectl config current-context)" = kind-susu-flux-lab
  sed "s|REPLACE_WITH_PUBLIC_REPO_URL|$LAB_REPO_URL|" gitops/flux-source.yaml | kubectl apply -f -
  kubectl apply -f gitops/flux-kustomization.yaml ;;
 *) echo 'Usage: bash scripts/06-connect-source.sh argo|flux https://...git'; exit 1;;
esac
