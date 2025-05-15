{ pkgs, lib, config, ... }:
let
  glunch = (pkgs.callPackage ./glunch.nix {});
in
{
  options = {
    glunch.enable = lib.mkEnableOption "enable glunch";
  };
  config = lib.mkIf config.glunch.enable {
    home.packages = with pkgs; [
      (pkgs.callPackage ./glunch.nix {})
    ];
  };
}
