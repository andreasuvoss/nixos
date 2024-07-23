{ pkgs, lib, config, ...}:
{
  options = {
    golang.enable = lib.mkEnableOption "enable golang";
  };
  config = lib.mkIf config.golang.enable {
    home.packages = with pkgs; [
      go
    ];
  };
}
