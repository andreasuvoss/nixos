{
  pkgs-unstable,
  lib,
  config,
  ...
}:
{
  options = {
    jetbrains-gateway.enable = lib.mkEnableOption "enable jetbrains-gateway";
  };
  config = lib.mkIf config.jetbrains-gateway.enable {
    home.packages = with pkgs-unstable; [ jetbrains.gateway ];
  };
}
