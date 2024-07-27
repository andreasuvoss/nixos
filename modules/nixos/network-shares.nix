{ pkgs, lib, config, ... }: 
let
  commonOptions = let
    automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
  in ["rw" "guest" "vers=3.0" "${automount_opts},uid=1000,gid=100"];

  shares = [
    "appdata"
    "data"
    "domains"
    "downloads"
    "isos"
    "media"
    "roms"
    "shared"
    "sync"
    "synctest"
    "system"
  ];

  mkFileSystem = share: {
    device = "//192.168.1.2/${share}";
    fsType = "cifs";
    options = commonOptions;
  };

  fileSystems = builtins.listToAttrs (map (share: {name = "/mnt/helium/${share}"; value = mkFileSystem share;}) shares);
in
{
  options = {
    network-shares.enable = lib.mkEnableOption "enables network-shares";
  };
  config = lib.mkIf config.network-shares.enable {
    environment.systemPackages = [ pkgs.cifs-utils ];
    fileSystems = fileSystems;
  };
}
