# TODO: Modularize the NixOS configuration
{ pkgs, config, ... }:{
  imports = [
    ./desktop.nix
    ./gaming.nix
    ./gnome-keyring.nix
    ./locale.nix
    ./network-shares.nix
    ./sound.nix
    ./virtualization.nix
  ];
  config = {
    # Enable zsh
    environment.shells = with pkgs; [ zsh ];
    users.defaultUserShell = pkgs.zsh;
    programs.zsh.enable = true;

    # Enable git
    programs.git.enable = true;
  };
}
