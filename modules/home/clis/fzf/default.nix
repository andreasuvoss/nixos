{ lib, config, ... }:
{
  options = {
    fzf.enable = lib.mkEnableOption "enable fzf" ;
  };
  config = lib.mkIf config.fzf.enable {
    programs.fzf = {
      enable = true;
      enableZshIntegration = config.zsh.enable;
      defaultCommand = "fd --type f --color=always";
    };
  };
}

