{ pkgs, lib, config, ...}:
{
  options = {
    nemo.enable = lib.mkEnableOption "enable nemo";
  };
  config = lib.mkIf config.nemo.enable {
    home.packages = with pkgs; [
      cinnamon.nemo
    ];
  };
}
