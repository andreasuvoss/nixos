{
  pkgs,
  lib,
  config,
  ...
}:
{
  options = {
    gaming.enable = lib.mkEnableOption "enables libraries needed for gaming";
  };
  config = lib.mkIf config.gaming.enable {
    # Gaming settings
    # https://youtu.be/qlfm3MEbqYA?si=SjIg2ab0Ka5N20Bs&t=336
    environment.systemPackages = with pkgs; [
      protonup
      mangohud
      wowup-cf
    ];

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    programs.gamemode.enable = true;
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    services.xserver.videoDrivers = [ "amdgpu" ];
  };
}
