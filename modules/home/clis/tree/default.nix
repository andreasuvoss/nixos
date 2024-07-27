{ pkgs, lib, config, ... }:
{
  options = {
    tree.enable = lib.mkEnableOption "enable tree";
  };
  config = lib.mkIf config.tree.enable {
    home.packages = with pkgs; [
      tree
    ];
  };
}
