{ pkgs, lib, config, ... }:
{
  options = {
    megasync.enable = lib.mkEnableOption "enable megasync";
  };
  config = lib.mkIf config.megasync.enable {
    home.packages = with pkgs; [
      megasync
    ];
  };
}
