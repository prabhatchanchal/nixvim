#!/bin/sh
# Unpacks the Nixvim portable bundle: stock Neovim + nixvim-generated config +
# vendored plugin sources. Installs under ~/.nixvim and ~/.config/nvim, so
# nothing needs Nix and no compiled store paths are referenced.
set -eu

here=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

prefix=$HOME/.nixvim
conf=$HOME/.config/nvim
marker=$conf/.nixvim-portable

# Replacing our own previous install is safe; a hand-written config is not.
if [ -e "$conf" ] && [ ! -f "$marker" ]; then
  backup=$conf.bak.$(date +%Y%m%d%H%M%S)
  echo "a Neovim config already exists at $conf"
  echo "moving it to $backup"
  mv "$conf" "$backup"
fi

rm -rf "$prefix/nvim" "$prefix/plugins" "$conf"
mkdir -p "$HOME/.config" "$prefix"
cp -R "$here/nvim" "$prefix/nvim"
cp -R "$here/plugins" "$prefix/plugins"
cp -R "$here/config" "$conf"
: >"$marker"

mkdir -p "$HOME/.local/bin"
ln -sf "$prefix/nvim/bin/nvim" "$HOME/.local/bin/nvim"

case ":$PATH:" in
*":$HOME/.local/bin:"*) ;;
*) echo "add \$HOME/.local/bin to your PATH, then run: nvim" ;;
esac

if [ -s "$here/needs-binaries.txt" ]; then
  echo
  echo "these tools were baked into the Nix build and must be on your PATH:"
  sed 's/^/  /' "$here/needs-binaries.txt"
fi

echo
echo "nvim installed -> $prefix/nvim/bin/nvim"
