{ pkgs, lib, config, ... }:
let
  shellAliases = {
    cat = "bat -p -n";
    ii = "xdg-open";
    nrb = "nixos-rebuild switch --flake .";
    bfzf = "fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'";
    db = "distrobox";
    tree = "eza --tree";
    q = "exit";
    ":q" = "exit";
  };
in
{
  options = {
    fish.enable = lib.mkEnableOption "enable fish";
  };
  config = lib.mkIf config.fish.enable {
    home.packages = with pkgs; [
      direnv
    ];
    home.sessionVariables.BAT_THEME = "Dracula";
    programs.fish = {
      enable = true;
      shellInit = ''
        fish_vi_key_bindings
        fish_config theme choose Dracula
        set fish_greeting
        starship init fish | source
        set -l fishconf (set -q XDG_CONFIG_HOME; and echo $XDG_CONFIG_HOME; or echo ~/.config)/fish
        source $fishconf/sensitive.fish

        # bind -M visual y '
        #   commandline -f kill-selection;
        #   commandline -b | wl-copy;
        #   commandline -f undo end-selection repaint
        # '
      '';
      inherit shellAliases;
    };
  };
}