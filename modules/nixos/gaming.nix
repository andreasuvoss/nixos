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
      # linuxKernel.packages.linux_zen.xone
      lact
    ];
    systemd.packages = with pkgs; [ lact ];
    systemd.services.lactd.wantedBy = [ "multi-user.target" ];

    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
    };
    programs.gamemode.enable = true;
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    hardware.steam-hardware.enable = true;
    hardware.xone.enable = true;
    services.xserver.videoDrivers = [ "amdgpu" ];
  };
}