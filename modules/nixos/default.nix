# TODO: Modularize the NixOS configuration
{ pkgs, config, ... }:
{
  imports = [
    ./desktop.nix
    ./gaming.nix
    ./locale.nix
    ./sound.nix
    ./virtualization.nix
  ];
  config = {
    nix.settings = {
      substituters = [ "https://hyprland.cachix.org" ];
      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };

    # Enable zsh
    environment.shells = with pkgs; [ zsh ];

    # Tailscale
    services.tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };

    # NFS shares
    environment.systemPackages = with pkgs; [
      nfs-utils
      home-manager
    ];

    users.defaultUserShell = pkgs.zsh;
    programs.zsh.enable = true;

    # Enable git
    programs.git.enable = true;

    # Enable flatpaks
    services.flatpak.enable = false;
  };
}
