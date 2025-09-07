{ pkgs-unstable, lib, config, ... }:
{
  options = {
    bitwarden.enable = lib.mkEnableOption "enables bitwarden";
  };
  config = lib.mkIf config.bitwarden.enable {
    home.packages = with pkgs-unstable; [
      bitwarden-desktop
    ];
  };
}