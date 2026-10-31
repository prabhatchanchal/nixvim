# Collects the generated config + every vim-plugin source referenced by the
# nixvim config into one portable payload for the Windows installer.
#
# Standalone nixvim bakes /nix/store paths into the config (VIMINIT points at
# build.initFile, runtimepath entries point at plugin derivations). Neovim
# expands `$VAR` and `~` in path options, so the CI job rewrites those store
# paths to `$LOCALAPPDATA/...` references — user-independent, no relocation
# of binaries needed since only lua/vimscript sources are portable.
{
  lib,
  runCommand,
  configuration,
}:
let
  cfg = configuration.config;

  pluginPackages = lib.unique (
    (lib.pipe cfg.plugins.byName [
      (lib.filterAttrs (_: p: p.enable && p.package != null))
      lib.attrValues
    ])
    ++ cfg.extraPlugins
  );

  configRoot = "$LOCALAPPDATA/nvim";
  pluginsRoot = "$LOCALAPPDATA/nvim-plugins";

  # { "/nix/store/hash-name" = "<local target>"; ... } for the CI rewrite step
  rewriteTargets =
    (lib.listToAttrs (
      map (pkg: lib.nameValuePair (toString pkg) "${pluginsRoot}/${lib.getName pkg}") pluginPackages
    )
    // {
      "${cfg.build.extraFiles}" = configRoot;
      "${cfg.build.initFile}" = "${configRoot}/init.lua";
    });
in
runCommand "nixvim-windows-payload" { }
  ''
    mkdir -p $out/plugins $out/config
    cp -rL --no-preserve=all ${cfg.build.extraFiles}/. $out/config/
    cp --no-preserve=all ${cfg.build.initFile} $out/config/init.lua
    ${lib.concatMapStringsSep "\n" (
      pkg: ''cp -rL --no-preserve=all ${pkg} "$out/plugins/${lib.getName pkg}"''
    ) pluginPackages}
    cat > $out/mapping.json <<JSON
    ${builtins.toJSON rewriteTargets}
    JSON
  ''
