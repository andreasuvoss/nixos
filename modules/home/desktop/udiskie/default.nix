{ pkgs, lib, config, ... }:
{
  options = {
    udiskie.enable = lib.mkEnableOption "enable udiskie";
  };
  config = lib.mkIf config.udiskie.enable {
    services.udiskie = {
      enable = true;
      notify = true;
      automount = true;
    };
    home.packages = with pkgs; [
      udiskie
    ];
  };
}
