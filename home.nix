{ lib, pkgs, nixpkgs, inputs, ... }:
let
  username = "andreasvoss";
in
{
  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnfreePredicate = (_: true);
  home = {
    # packages = with pkgs; [
    #   # megasync
    # ];
    inherit username;
    homeDirectory = "/home/${username}";

    stateVersion = "24.05";

    # TODO: Remove this later
    file = {
      "testfile.json" = {
        text = builtins.toJSON inputs;
        executable = false;
      };
      # ".config/alacritty/alacritty.toml".source = ./dotfiles2/alacritty/.config/alacritty/alacritty.toml;
      #".config/alacritty/dracula.toml".source = ./dotfiles2/alacritty/.config/alacritty/dracula.toml;
      # ".config/alacritty/alacritty.toml".source = ./dotfiles2/alacritty/.config/alacritty/alacritty.toml;
    };

  };
  # programs.zsh = {
  #   enable = true;
  #   autosuggestion.enable = true;
  #   syntaxHighlighting.enable = true;
  #   enableCompletion = true;
  #   inherit shellAliases;
  # };
}
