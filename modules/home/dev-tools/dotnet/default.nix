{ pkgs, lib, config, ... }:
{
  options = {
    dotnet.enable = lib.mkEnableOption "enable dotnet";
  };
  config = lib.mkIf config.dotnet.enable {
    home.packages = with pkgs; [
      (with dotnetCorePackages; combinePackages [
        sdk_7_0_3xx
        sdk_8_0_2xx
        sdk_9_0 
      ])
    ];
  };
}
