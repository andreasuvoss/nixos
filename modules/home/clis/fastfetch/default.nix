{ pkgs, lib, config, ... }:
{
  options = {
    fastfetch.enable = lib.mkEnableOption "enable fastfetch";
  };
  config = lib.mkIf config.fastfetch.enable {
    programs.fastfetch = {
      enable = true;
      package = pkgs.fastfetch;
      # settings = {
      #   logo = {
      #     type = "builtin";
      #     padding = {
      #       right = 1;
      #     };
      #   };
      #   modules = [];
      # };
    };
  };
}