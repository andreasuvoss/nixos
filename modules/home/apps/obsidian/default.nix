{ pkgs-unstable, lib, config, ... }:
{
  options = {
    obsidian.enable = lib.mkEnableOption "enables obsidian";
  };
  config = lib.mkIf config.obsidian.enable {
    # TODO: After next Nix release use the home manager module
    # programs.obsidian.enable = true;
    home.packages = with pkgs-unstable; [
      obsidian
    ];
  };
}