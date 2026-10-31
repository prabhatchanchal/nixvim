#!/bin/sh
# Hygiene gate for the packaged bundles: an installed tree that still names a
# store path only works on the machine that built it. Writes store-report.txt
# with the surviving paths and the files carrying them.
set -u

report=store-report.txt
files=$(mktemp)
: >"$files"

for dir in "$@"; do
  if [ ! -d "$dir" ]; then
    printf 'missing install directory: %s\n' "$dir" >>"$files"
    continue
  fi
  grep -rlI '/nix/store/' "$dir" >>"$files" 2>/dev/null || :
done

if [ ! -s "$files" ]; then
  rm -f "$files"
  exit 0
fi

{
  printf 'surviving store paths (count, path):\n'
  while IFS= read -r f; do
    grep -hoE '/nix/store/[A-Za-z0-9._+-]+' "$f" 2>/dev/null || :
  done <"$files" | sort | uniq -c | sort -rn | head -n 20
  printf 'files carrying them:\n'
  head -n 20 "$files"
} >"$report"

rm -f "$files"
exit 1
