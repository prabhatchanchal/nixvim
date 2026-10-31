# Collects the generated config + every /nix/store path it references into one
# portable payload for the Windows installer.
#
# Standalone nixvim bakes store paths into the config: VIMINIT points at
# build.initFile, and runtimepath entries point at plugin derivations. Those
# are pure lua/vimscript sources, so they are portable; Neovim expands `$VAR`
# in path options, so the CI job rewrites the absolute store paths to
# `$LOCALAPPDATA/...` — user-independent, and no binary relocation needed.
{
  lib,
  runCommand,
  configuration,
}:
let
  cfg = configuration.config;
in
runCommand "nixvim-windows-payload" { }
  ''
    set -euo pipefail
    mkdir -p $out/plugins $out/config

    cp -rL --no-preserve=all ${cfg.build.extraFiles}/. $out/config/
    cp --no-preserve=all ${cfg.build.initFile} $out/config/init.lua

    # Vendor every store path referenced by the generated config.
    # Paths nested inside an already-copied directory travel with it and are
    # not rewritten individually.
    grep -ohE '/nix/store/[a-z0-9]{32}-[A-Za-z0-9+._?=-]+' $out/config -r \
      | sort -u > referenced.txt

    : > $out/mapping.tsv
    while IFS= read -r p; do
      [ -e "$p" ] || continue
      name=$(basename "$p")
      case "$p" in
        ${cfg.build.extraFiles}|${cfg.build.initFile}) continue ;;
      esac
      if [ -d "$p" ]; then
        cp -rL --no-preserve=all "$p" "$out/plugins/$name"
      else
        cp -L --no-preserve=all "$p" "$out/plugins/$name"
      fi
      printf '%s\t%s\n' "$p" "\$LOCALAPPDATA/nvim-plugins/$name" >> $out/mapping.tsv
    done < referenced.txt

    printf '%s\t%s\n' '${cfg.build.extraFiles}' "\$LOCALAPPDATA/nvim" >> $out/mapping.tsv
    printf '%s\t%s\n' '${cfg.build.initFile}' "\$LOCALAPPDATA/nvim/init.lua" >> $out/mapping.tsv
  ''
