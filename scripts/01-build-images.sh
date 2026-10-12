#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
docker build -t susu-haven:v1 .
docker build --build-arg SITE_FILE=index-v2.html -t susu-haven:v2 .
printf '%s\n' 'Built v1 and v2. No cluster has been changed.'
