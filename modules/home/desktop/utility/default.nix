{ pkgs, lib, config, ... }:{
  options = {
    desktop-utility.enable = lib.mkEnableOption "enables desktop-utility";
  };
  config = lib.mkIf config.desktop-utility.enable {
    home.packages = with pkgs; [
      ffmpeg
      pavucontrol
    ];
  };
}
