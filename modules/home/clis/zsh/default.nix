{ lib, config, ... }:
let
  shellAliases = {
    cat = "bat -P -n";
    ii = "xdg-open";
    nrb = "nixos-rebuild switch --flake .";
  };
in
{
  options = {
    zsh.enable = lib.mkEnableOption "enable zsh";
    zsh.ssh-agent.enable = lib.mkEnableOption "enable ssh-agent in zsh";
  };
  config = lib.mkIf config.zsh.enable {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      initExtra = builtins.readFile ./config.zsh + (if config.zsh.ssh-agent.enable then builtins.readFile ./ssh-agent.zsh else "");
      envExtra = "export BAT_THEME=\"Dracula\"";
      inherit shellAliases;
    };
  };
}
