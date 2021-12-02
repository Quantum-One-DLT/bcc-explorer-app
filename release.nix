############################################################################
#
# Hydra release jobset.
#
# The purpose of this file is to select jobs defined in default.nix and map
# them to all supported build platforms.
#
############################################################################
{
  bcc-explorer-app ? { rev = null; }
}:

let
  pkgs = import ./nix/pkgs.nix {};

in

pkgs.lib.fix (self: {
  inherit ( import ./. ) allowList bcc-explorer-app static;
  build-version = pkgs.writeText "version.json" (builtins.toJSON { inherit (bcc-explorer-app) rev; });
  required = pkgs.releaseTools.aggregate {
    name = "required";
    constituents = with self; [
      allowList
      build-version
      static
    ];
  };
})
