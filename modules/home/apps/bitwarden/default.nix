{ pkgs-unstable, lib, config, ... }:
let
  unstableWithOverrides = pkgs-unstable.extend (final: prev: {
    bitwarden-desktop = prev.bitwarden-desktop.override {
      electron_39 = final.electron_39-bin;
    };
  });
in
{
  options = {
    bitwarden.enable = lib.mkEnableOption "enables bitwarden";
  };
  config = lib.mkIf config.bitwarden.enable {
    home.packages = [
      unstableWithOverrides.bitwarden-desktop
    ];
  };
}