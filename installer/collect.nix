# Collects the generated config + every vim-plugin source referenced by the
# nixvim config into one payload. Used by the Windows installer job: nix
# cannot build a native Windows closure, but lua-only plugin *sources* are
# portable; store paths in the generated config are rewritten to local
# plugin dirs at packaging time (see mapping.json consumer in the workflow).
{
  lib,
  runCommand,
  system ? "x86_64-linux",
}:
let
  evaluated = builtins.getFlake (toString ./..);
  configuration = evaluated.lib.nixvim.evalNixvim {
    inherit system;
    modules = [ ./config/nixvim-config.nix ];
  };
  cfg = configuration.config;

  pluginPackages = lib.unique (
    (lib.pipe cfg.plugins.byName [
      (lib.filterAttrs (_: p: p.enable && p.package != null))
      lib.attrValues
    ])
    ++ cfg.extraPlugins
  );

  # { "/nix/store/hash-name" = "name"; ... } for the CI rewrite step
  pathToName = lib.listToAttrs (
    map (pkg: lib.nameValuePair (toString pkg) (lib.getName pkg)) pluginPackages
  );
in
runCommand "nixvim-windows-payload" { }
  ''
    mkdir -p $out/plugins $out/config
    cp -r --no-preserve=all ${cfg.build.extraFiles}/nvim/* $out/config/
    ${lib.concatMapStringsSep "\n" (
      pkg: ''cp -r --no-preserve=all ${pkg} "$out/plugins/${lib.getName pkg}"''
    ) pluginPackages}
    cat > $out/mapping.json <<JSON
    ${builtins.toJSON pathToName}
    JSON
  ''
