{ pkgs, lib, config, ... }:
{
  options = {
    bicep.enable = lib.mkEnableOption "enable bicep";
  };
  config = lib.mkIf config.bicep.enable {
    home.packages = with pkgs; [
      bicep
    ];
  };
}
