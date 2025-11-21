{ pkgs, lib, config, ... }:
{
  options = {
    carapace.enable = lib.mkEnableOption "enable carapace";
  };
  config = lib.mkIf config.carapace.enable {
    programs.carapace = {
      enable = true;
      enableZshIntegration = true;
    };
  };
}