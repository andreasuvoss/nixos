{ pkgs, lib, config, ... }:
{
  options = {
    yq.enable = lib.mkEnableOption "enable yq";
  };
  config = lib.mkIf config.yq.enable {
    home.packages = with pkgs; [
      yq
    ];
  };
}
