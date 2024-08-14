{ pkgs, pkgs-unstable, lib, config, ... }:
{
  options = {
    azure-cli.enable = lib.mkEnableOption "enable azure-cli";
  };
  config = lib.mkIf config.azure-cli.enable {
    home.packages = with pkgs; [
      (azure-cli.withExtensions [
        azure-cli.extensions.azure-devops
      ])
    ];
    # home.packages = with pkgs-unstable; [
    #   (azure-cli.withExtensions [
    #     azure-cli.extensions.application-insights 
    #     azure-cli.extensions.azure-devops
    #   ])
    # ];
  };
}
