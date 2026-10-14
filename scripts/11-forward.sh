#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
source scripts/common.sh
require_lab
case "${1:-}" in
 website) printf '%s\n' 'Open http://localhost:8080 ; keep this terminal open.'; k -n lab port-forward service/susu-haven 8080:80 ;;
 argo) printf '%s\n' 'Open https://localhost:8081 ; keep this terminal open.'; k -n argocd port-forward service/argocd-server 8081:443 ;;
 *) printf '%s\n' 'Usage: bash scripts/11-forward.sh website|argo'; exit 1 ;;
esac
