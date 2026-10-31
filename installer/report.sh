#!/bin/sh
# CI scaffolding: this fork's job logs need auth to read, so a failed step
# files the tail of its log as an issue that can be read back anonymously.
set -eu

log=${1:-build.log}
label=${2:-job}

{
  printf 'Run: https://github.com/%s/actions/runs/%s\n\n' \
    "$GITHUB_REPOSITORY" "$GITHUB_RUN_ID"
  printf '```\n'
  tail -c 5000 "$log" 2>/dev/null || printf '(nothing captured)\n'
  printf '```\n'
} > "report-$label.md"

gh issue create \
  --repo "$GITHUB_REPOSITORY" \
  --title "[installer] $label failed" \
  --body-file "report-$label.md"
