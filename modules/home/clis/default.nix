{ lib, config, ... }:{
  imports = [
    ./az-cred-provider
    ./starship
    ./git
    ./gum
    ./tmux
    ./zsh
    ./yazi
    ./tlrc
    ./misc
    ./nvim
  ];
  options = {
    clis.enable = lib.mkEnableOption "enable clis";
  };
  config = lib.mkIf config.clis.enable {
    az-cred-provider.enable = true;
    git.enable = true;
    gum.enable = true;
    misc.enable = true;
    nvim.enable = true;
    starship.enable = true;
    tldr.enable = true;
    tmux.enable = true;
    yazi.enable = true;
    zsh.enable = true;
  };
}
