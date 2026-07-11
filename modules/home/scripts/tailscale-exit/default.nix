{ lib, config, ... }:
{
  options = {
    tailscale-exit.enable = lib.mkEnableOption "enable tailscale-exit" ;
  };
  config = lib.mkIf config.tailscale-exit.enable {
    home.file.".scripts/tailscale-exit.sh" = {
      enable = true;
      executable = true;
      source = ./tailscale-exit.sh;
    };
  };
}