#!/usr/bin/env bash
# Rewrites /nix/store paths in the collected payload to portable $LOCALAPPDATA
# paths, so the config works against a stock Windows Neovim.
#
# Usage: rewrite.sh <payload> <dest-staging-dir>
set -euo pipefail

payload=$1
dest=$2

rm -rf "$dest"
mkdir -p "$dest"
cp -rL --no-preserve=all "$payload/config" "$dest/"
cp -rL --no-preserve=all "$payload/plugins" "$dest/"

awk -F '\t' '{ printf "s|%s|%s|g\n", $1, $2 }' "$payload/mapping.tsv" > "$dest/rewrite.sed"
find "$dest/config" "$dest/plugins" -type f -print0 | xargs -0 sed -i -f "$dest/rewrite.sed"
rm "$dest/rewrite.sed"

# Anything still pointing at the store is a compiled dependency we cannot
# relocate; surface it instead of shipping a silently broken config.
# nix-support metadata and a plugin's own dev scripts are never read by nvim.
leftovers=$(
  grep -rlI '/nix/store/' "$dest/config" "$dest/plugins" \
    | grep -v -E '(^|/)nix-support/|/scripts/' || true
)
if [ -n "$leftovers" ]; then
  echo "::warning::unrewritten /nix/store references remain:"
  printf '%s\n' "$leftovers" | head -20
  printf '%s\n' "$leftovers" > "$dest/unresolved.txt"
fi

cp "$payload/needs-binaries.txt" "$dest/needs-binaries.txt"
echo "staged payload -> $dest"
