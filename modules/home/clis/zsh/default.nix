{...}:
let
  shellAliases = {
    cat = "bat -P -n";
    ii = "xdg-open";
    nrb = "nixos-rebuild switch --flake .";
  };
in
{
  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;
    initExtra = builtins.readFile ./config.zsh;
    envExtra = "export BAT_THEME=\"Dracula\"";
    inherit shellAliases;
  };
}
