{ pkgs, lib, config, inputs, ... }:
{
  options = {
    glunch.enable = lib.mkEnableOption "enable glunch";
  };
  config = lib.mkIf config.glunch.enable {
    home.packages = [
      inputs.glunch.packages.${pkgs.stdenv.hostPlatform.system}.default
    ];
  };
}