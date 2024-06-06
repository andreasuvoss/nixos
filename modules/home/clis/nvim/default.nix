# TODO: declare all things nvim related using Nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    neovim
  ];
}
