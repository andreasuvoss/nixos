{ pkgs, lib, config, ... }:
{
  options = {
    tmux.enable = lib.mkEnableOption "enable tmux";
  };
  config = lib.mkIf config.tmux.enable {
    programs.tmux = {
      enable = true;
      extraConfig = builtins.readFile ./tmux.conf;

      plugins = with pkgs.tmuxPlugins; [
        {
          plugin = dracula;
          extraConfig = ''
            set -g @dracula-show-fahrenheit false
            set -g @dracula-show-location false
            set -g @dracula-show-powerline true
          '';
        }
      ];
    };
  };
}
