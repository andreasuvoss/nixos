{ pkgs, lib, config, ... }:
{
  options = {
    iperf.enable = lib.mkEnableOption "enable iperf";
  };
  config = lib.mkIf config.iperf.enable {
    home.packages = with pkgs; [
      iperf
    ];
  };
}
