#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
test "$(kubectl config current-context)" = kind-susu-flux-lab || { echo 'Select kind-susu-flux-lab first.'; exit 1; }
flux check --pre
flux install
flux check
