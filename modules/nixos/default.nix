# TODO: Modularize the NixOS configuration
{ pkgs, config, ... }:
{
  imports = [
    ./desktop.nix
    ./gaming.nix
    ./gnome-keyring.nix
    ./locale.nix
    ./sound.nix
    ./virtualization.nix
  ];
  config = {
    # Enable zsh
    environment.shells = with pkgs; [ zsh ];
    
    # Tailscale
    services.tailscale.enable = true;

    # NFS shares
    environment.systemPackages = with pkgs; [ nfs-utils ];

    users.defaultUserShell = pkgs.zsh;
    programs.zsh.enable = true;

    # Enable git
    programs.git.enable = true;

    # Enable flatpaks
    services.flatpak.enable = false;
  };
}
