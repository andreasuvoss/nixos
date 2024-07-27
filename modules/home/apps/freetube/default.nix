{ pkgs, pkgs-unstable, lib, config, ... }:
let
  # I'm still getting the old version with this override, so I dont know what is going on
  freetube-updated = pkgs.callPackage ./freetube-override.nix {  pkgs = pkgs-unstable; };
in
{
  options = {
    freetube.enable = lib.mkEnableOption "enable freetube";
  };
  config = lib.mkIf config.freetube.enable {
    home.packages = [
      pkgs-unstable.freetube
      # freetube-updated
    ];
  };
}
