{ pkgs, lib, config, ... }:
{
  options = {
    jq.enable = lib.mkEnableOption "enable jq";
  };
  config = lib.mkIf config.jq.enable {
    home.packages = with pkgs; [
      jq
    ];
  };
}
