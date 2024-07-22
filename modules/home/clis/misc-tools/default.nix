{ pkgs, pkgs-master, lib, ... }:
{
  home.packages = with pkgs; [
    ueberzugpp
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
    stow
    gparted
    tlrc
    (pkgs-master.azure-cli.withExtensions [
      pkgs-master.azure-cli.extensions.application-insights 
      pkgs-master.azure-cli.extensions.azure-devops
    ])
  ];
}
