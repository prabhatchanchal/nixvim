# Builds the portable payload used by the Windows and macOS installers.
#
# Standalone nixvim puts plugin paths on the runtimepath through flags baked
# into its neovim *wrapper script*, and injects init.lua via VIMINIT. A stock
# neovim from the official release archives has neither, so this reconstructs
# an equivalent config:
#   - runtimepath entries appended from <pluginRoot>/<name>
#   - the generated init.lua, with host-provider lines stripped
# Compiled dependencies (ruby/python providers, external tools) cannot be
# relocated, so they are reported in needs-binaries.txt.
#
# configRoot/pluginRoot are the *end-user* paths the installer drops files at;
# they are emitted verbatim, so they may contain shell variables that neovim
# expands at startup ($LOCALAPPDATA on windows, $HOME on unix).
{
  lib,
  runCommand,
  configuration,
  configRoot ? "$LOCALAPPDATA/nvim",
  pluginRoot ? "$LOCALAPPDATA/nvim-plugins",
}:
let
  cfg = configuration.config;

  # extraPlugins accepts either a bare package or a { plugin, config, optional } set
  unwrapPlugin = p: if p ? plugin then p.plugin else p;

  # nixpkgs vim plugins declare their runtime dependencies through the
  # `dependencies` attribute, and neovim's wrapper flattens that closure onto the
  # runtimepath. Vendoring only the top-level list leaves plugins that require()
  # their dependencies unloadable (telescope needs plenary).
  depsOf = pkg: if builtins.isAttrs pkg && pkg ? dependencies then pkg.dependencies else [ ];

  dependencyClosure =
    pkg:
    [ pkg ] ++ builtins.concatMap dependencyClosure (depsOf pkg);

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

  # Keyed by that label: two versions of one plugin would otherwise collide as
  # duplicate attributes. The first occurrence wins, as lib.unique would decide.
  pluginPackages = lib.attrValues (
    builtins.foldl' (
      acc: pkg:
      let n = pluginName pkg; in acc // { "${n}" = acc."${n}" or pkg; }
    ) { }
    (
      lib.unique (
        builtins.concatMap dependencyClosure (
          builtins.filter (pkg: pkg != null && pkg != cfg.build.extraFiles) (map unwrapPlugin cfg.extraPlugins)
        )
      )
    )
  );

  rtpPrelude = lib.concatStringsSep "\n" (
    map (
      pkg:
      ''
        vim.opt.runtimepath:append(vim.fn.expand("${pluginRoot}/${pluginName pkg}"))
      ''
    ) pluginPackages
  );

  # the roots reach bash inside double quotes, so their `$` must be escaped to
  # survive into mapping.tsv rather than expanding to nothing
  escapeRoot = lib.replaceStrings [ "$" ] [ "\\$" ];

in
runCommand "nixvim-portable-payload" { }
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
      pkg: ''printf '%s\t%s\n' '${toString pkg}' "${escapeRoot pluginRoot}/${pluginName pkg}" >> $out/mapping.tsv''
    ) pluginPackages}
    printf '%s\t%s\n' '${toString cfg.build.extraFiles}' "${escapeRoot configRoot}" >> $out/mapping.tsv

    printf '%s\n' ${lib.concatMapStringsSep " " (p: "\"${pluginName p}\"") cfg.extraPackages} \
      > $out/needs-binaries.txt
  ''
