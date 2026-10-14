#!/usr/bin/env bash
# Shared local-lab settings. Resource names match the earlier practice kit.
set -euo pipefail
LAB_CLUSTER=susu-argo-lab
LAB_CONTEXT=kind-susu-argo-lab
LAB_NAMESPACE=lab
LAB_APP=susu-haven
require_tool() { command -v "$1" >/dev/null 2>&1 || { printf 'Missing tool: %s\n' "$1" >&2; exit 1; }; }
require_lab() {
  require_tool kubectl
  local selected
  selected="$(kubectl config current-context)"
  test "$selected" = "$LAB_CONTEXT" || { printf 'Select the local lab first: kubectl config use-context %s\nCurrent context: %s\n' "$LAB_CONTEXT" "$selected" >&2; exit 1; }
}
k() { kubectl --context "$LAB_CONTEXT" "$@"; }
