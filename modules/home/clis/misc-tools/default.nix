{ pkgs, pkgs-master, lib, ... }:
{
  services.ssh-agent.enable = true;
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
    pkgs-master.azure-cli # When my commit gets merged to master install the extension
    # (pkgs-master.azure-cli.withExtensions [ azure-cli.extensions.application-insights ])
    # Can't get the patch to work
    # (pkgs-master.azure-cli.overrideAttrs (old: {
    #   patches = [ ./nixos-nixpkgs-316386.patch ]; }))
  ];
}
