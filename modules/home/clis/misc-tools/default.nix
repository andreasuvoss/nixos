{ pkgs, ... }:
{
  home.packages = with pkgs; [
    jq
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
    azure-cli
  ];
}
