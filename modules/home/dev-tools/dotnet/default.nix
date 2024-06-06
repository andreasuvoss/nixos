{ pkgs, ... }:
{
  home.packages = with pkgs; [
    (with dotnetCorePackages; combinePackages [
      sdk_7_0_3xx
      sdk_8_0_2xx
      sdk_9_0 
    ])
  ];
}
