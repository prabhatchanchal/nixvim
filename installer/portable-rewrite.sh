#!/bin/sh
# Rewrites /nix/store paths in the collected payload to the portable roots the
# installer unpacks to, so the config works against a stock Neovim.
# Runs on both Linux and macOS, so no GNU-only flags here.
#
# Usage: portable-rewrite.sh <payload> <dest-staging-dir>
set -eu

payload=$1
dest=$2

rm -rf "$dest"
mkdir -p "$dest"
cp -RL "$payload/config" "$dest/"
cp -RL "$payload/plugins" "$dest/"
# the store is read-only; cp -RL carries those modes over
chmod -R u+w "$dest"

awk -F '\t' '{ printf "s|%s|%s|g\n", $1, $2 }' "$payload/mapping.tsv" > "$dest/rewrite.sed"

find "$dest/config" "$dest/plugins" -type f -exec sh -c '
  sedfile=$1
  shift
  for f in "$@"; do
    sed -f "$sedfile" "$f" > "$f.rewritten" && mv "$f.rewritten" "$f"
  done
' _ "$dest/rewrite.sed" {} +

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
