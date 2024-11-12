{ pkgs-unstable, lib, config, ... }:
{
  options = {
    azuredatastudio.enable = lib.mkEnableOption "enable azuredatastudio";
  };
  config = lib.mkIf config.azuredatastudio.enable {
    home.packages = with pkgs-unstable; [
      azuredatastudio
    ];
  };
}
