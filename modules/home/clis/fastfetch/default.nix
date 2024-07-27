{ pkgs, lib, config, ... }:
{
  options = {
    fastfetch.enable = lib.mkEnableOption "enable fastfetch";
  };
  config = lib.mkIf config.fastfetch.enable {
    home.packages = with pkgs; [
      fastfetch
    ];
  };
}
