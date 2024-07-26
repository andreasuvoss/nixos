{ pkgs, pkgs-master, lib, config, ... }:
{
  options = {
    misc.enable = lib.mkEnableOption "enable misc";
  };
  config = lib.mkIf config.misc.enable {
    home.packages = with pkgs; [
      jq
      ripgrep
      yq
      bat
      tree-sitter
      nodejs_22
      gcc
      tree
      curl
      fastfetch
      taskwarrior3
      ripgrep
      htop
      stow
      gparted
      (pkgs-master.azure-cli.withExtensions [
        pkgs-master.azure-cli.extensions.application-insights 
        pkgs-master.azure-cli.extensions.azure-devops
      ])
    ];
  };
}
