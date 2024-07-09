{ lib, pkgs, nixpkgs, ... }:
let
  username = "nixos";
in
{
  imports = [
    ./../../modules/home/clis/starship
    ./../../modules/home/clis/git
    ./../../modules/home/clis/tmux
    ./../../modules/home/clis/zsh
    ./../../modules/home/clis/swappy
    ./../../modules/home/clis/yazi
    ./../../modules/home/clis/tlrc
    ./../../modules/home/clis/misc-tools
    ./../../modules/home/clis/nvim
    ./../../modules/home/dev-tools
  ];
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (_: true);
  home.packages = with pkgs; [
    wl-clipboard
  ];
  home = {
    # packages = with pkgs; [
    #   # megasync
    # ];
    inherit username;
    homeDirectory = "/home/${username}";

    stateVersion = "24.05";


    file = {
      # ".config/alacritty/alacritty.toml".source = ./dotfiles2/alacritty/.config/alacritty/alacritty.toml;
      #".config/alacritty/dracula.toml".source = ./dotfiles2/alacritty/.config/alacritty/dracula.toml;
      # ".config/alacritty/alacritty.toml".source = ./dotfiles2/alacritty/.config/alacritty/alacritty.toml;
    };

  };
}
