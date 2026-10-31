# Builds the portable payload for the Windows installer.
#
# Standalone nixvim puts plugin paths on the runtimepath through flags baked
# into its neovim *wrapper script*, and injects init.lua via VIMINIT. A stock
# Windows neovim has neither, so this reconstructs an equivalent config:
#   - runtimepath entries appended from $LOCALAPPDATA/nvim-plugins/<name>
#   - the generated init.lua, with linux host-provider lines stripped
# Compiled dependencies (ruby/python providers, external tools) cannot be
# relocated, so they are reported in needs-binaries.txt.
{
  lib,
  runCommand,
  configuration,
}:
let
  cfg = configuration.config;

  # extraPlugins accepts either a bare package or a { plugin, config, optional } set
  unwrapPlugin = p: if p ? plugin then p.plugin else p;

  # keyed by plugin name so duplicate names collapse to one vendored copy.
  # build.extraFiles is the config dir itself (already copied), not a plugin.
  pluginPackages = lib.attrValues (
    lib.listToAttrs (
      map (p: lib.nameValuePair (pluginName p) p) (
        lib.unique (
          lib.filter (p: p != null && p != cfg.build.extraFiles) (map unwrapPlugin cfg.extraPlugins)
        )
      )
    )
  );

  # Some entries (lua packages, the generated config dir) carry neither `name`
  # nor `pname`, so derive the label from the store path itself.
  pluginName =
    pkg:
    let
      b = baseNameOf (toString pkg);
    in
    # the name is only a label; drop its store-path context so it can be
    # interpolated into the prelude file and shell snippets
    builtins.unsafeDiscardStringContext (builtins.substring 33 (builtins.stringLength b - 33) b);

  rtpPrelude = lib.concatStringsSep "\n" (
    map (
      pkg:
      ''
        vim.opt.runtimepath:append(vim.fn.expand("$LOCALAPPDATA/nvim-plugins/${pluginName pkg}"))
      ''
    ) pluginPackages
  );

in
runCommand "nixvim-windows-payload" { }
  ''
    set -euo pipefail
    mkdir -p $out/plugins $out/config

    cp -rL --no-preserve=all ${cfg.build.extraFiles}/. $out/config/

    # Prelude first: plugins must be on the rtp before the generated config
    # calls require() on them
    {
      echo '" Nixvim portable bundle: runtimepath reconstructed from vendored plugins'
      cat ${builtins.toFile "rtp-prelude.lua" rtpPrelude}
      sed '/_host_prog/d' ${cfg.build.initFile}
    } > $out/config/init.lua

    ${lib.concatMapStringsSep "\n" (
      pkg: ''cp -rL --no-preserve=all ${pkg} "$out/plugins/${pluginName pkg}"''
    ) pluginPackages}

    ${lib.concatMapStringsSep "\n" (
      pkg: ''printf '%s\t%s\n' '${toString pkg}' "\$LOCALAPPDATA/nvim-plugins/${pluginName pkg}" >> $out/mapping.tsv''
    ) pluginPackages}
    printf '%s\t%s\n' '${toString cfg.build.extraFiles}' "\$LOCALAPPDATA/nvim" >> $out/mapping.tsv

    printf '%s\n' ${lib.concatMapStringsSep " " (p: "\"${pluginName p}\"") cfg.extraPackages} \
      > $out/needs-binaries.txt
  ''
