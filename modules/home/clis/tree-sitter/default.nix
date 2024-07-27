{ pkgs, lib, config, ... }:
{
  options = {
    tree-sitter.enable = lib.mkEnableOption "enable tree-sitter";
  };
  config = lib.mkIf config.tree-sitter.enable {
    home.packages = with pkgs; [
      tree-sitter
    ];
  };
}
