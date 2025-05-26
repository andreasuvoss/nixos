{ pkgs, lib, config, ... }:
let
  shellAliases = {
    cat = "bat -P -n";
    ii = "xdg-open";
    nrb = "nixos-rebuild switch --flake .";
    bfzf = "fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'";
    rdr = "rider > /dev/null 2>&1";
  };
in
{
  options = {
    zsh.enable = lib.mkEnableOption "enable zsh";
  };
  config = lib.mkIf config.zsh.enable {
    home.packages = with pkgs; [
      direnv
    ];
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      enableCompletion = true;
      initContent = builtins.readFile ./config.zsh + (if config.keychain.enable then ''
        eval $(keychain --eval --agents ssh -q ${config.keychain.keyfile})
      ''
      else "");
      envExtra = "export BAT_THEME=\"Dracula\"";
      inherit shellAliases;
    };
  };
}
