{ lib, config, ... }:{
  imports = [
    ./az-cred-provider
    ./azure-cli
    ./bat
    ./curl
    ./fastfetch
    ./gcc
    ./git
    ./glow
    ./gparted
    ./gum
    ./htop
    ./jq
    ./keychain
    ./lazygit
    ./nodejs
    ./nvim
    ./ripgrep
    ./starship
    ./stow
    ./taskwarrior
    ./tldr
    ./tmux
    ./tree
    ./tree-sitter
    ./unzip
    ./vhs
    ./yazi
    ./yq
    ./zsh
  ];
  options = {
    clis.enable = lib.mkEnableOption "enable clis";
  };
  config = lib.mkIf config.clis.enable {
    az-cred-provider.enable = true;
    azure-cli.enable = true;
    bat.enable = true;
    curl.enable = true;
    fastfetch.enable = true;
    git.enable = true;
    glow.enable = true;
    gparted.enable = false;
    gum.enable = true;
    htop.enable = true;
    jq.enable = true;
    # keychain.enable = false;
    lazygit.enable = true;
    nodejs.enable = true;
    nvim.enable = true;
    ripgrep.enable = true;
    starship.enable = true;
    stow.enable = false;
    taskwarrior.enable = true;
    tldr.enable = true;
    tmux.enable = true;
    tree.enable = true;
    tree-sitter.enable = true;
    unzip.enable = true;
    vhs.enable = false;
    yazi.enable = true;
    yq.enable = true;
    zsh.enable = true;
  };
}
