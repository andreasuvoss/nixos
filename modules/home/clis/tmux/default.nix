{ lib, config, ... }:
{
  options = {
    tmux.enable = lib.mkEnableOption "enable tmux";
  };
  config = lib.mkIf config.tmux.enable {
    programs.tmux = {
      enable = true;
      extraConfig = builtins.readFile ./tmux.conf;
    };
  };
}
