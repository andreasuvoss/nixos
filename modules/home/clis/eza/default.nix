{ lib, config, ... }:
{
  options = {
    eza.enable = lib.mkEnableOption "enable eza" ;
  };
  config = lib.mkIf config.eza.enable {
    home.file.".config/eza/theme.yml" = {
      text = builtins.readFile ./theme.yml;
      executable = false;
    };
    programs.eza = {
      enable = true;
      enableZshIntegration = config.zsh.enable;
      git = true;
    };
  };
}

