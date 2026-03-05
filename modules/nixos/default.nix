# TODO: Modularize the NixOS configuration
{ pkgs, pkgs-unstable, config, ... }:
{
  imports = [
    ./desktop.nix
    ./gaming.nix
    ./locale.nix
    ./sound.nix
    ./virtualization.nix
  ];
  config = {
    # Enable zsh
    # environment.shells = with pkgs; [ zsh ];

    # Enable fish
    environment.shells = with pkgs; [ fish ];

    environment.localBinInPath = true;


    # Tailscale
    services.tailscale = {
      enable = true;
      package = pkgs-unstable.tailscale;
      useRoutingFeatures = "client";
      extraSetFlags = [
        "--operator=andreasvoss"
      ];
    };
    services.upower.enable = true;

    # NFS shares
    environment.systemPackages = with pkgs; [ nfs-utils home-manager restic ];

    # users.defaultUserShell = pkgs.zsh;
    # programs.zsh.enable = true;
    users.defaultUserShell = pkgs.fish;
    programs.fish.enable = true;

    # Enable git
    programs.git.enable = true;

    programs.ssh.kexAlgorithms = config.services.openssh.settings.KexAlgorithms;

    # Enable flatpaks
    services.flatpak.enable = false;
  };
}