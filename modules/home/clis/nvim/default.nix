# TODO: declare all things nvim related using Nix
{ pkgs, ... }:
{
  # home.packages = with pkgs; [
  #   neovim
  # ];
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };
}
