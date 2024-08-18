{ lib, config, ... }:{
  imports = [
    ./az-cred-provider
    ./azure-cli
    ./bat
    ./bicep
    ./curl
    ./fastfetch
    ./fzf
    ./gcc
    ./git
    ./glow
    ./gparted
    ./gum
    ./iperf
    ./btop
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
    ./udisks
    ./unzip
    ./vhs
    ./yazi
    ./yq
    ./zoxide
    ./zsh
  ];
  options = {
    clis.enable = lib.mkEnableOption "enable clis";
  };
  config = lib.mkIf config.clis.enable {
    az-cred-provider.enable = true;
    azure-cli.enable = true;
    bat.enable = true;
    bicep.enable = true;
    btop.enable = true;
    curl.enable = true;
    fastfetch.enable = true;
    fzf.enable = true;
    git.enable = true;
    glow.enable = true;
    gparted.enable = false;
    gum.enable = true;
    iperf.enable = true;
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
    udisks.enable = true;
    unzip.enable = true;
    vhs.enable = false;
    yazi.enable = true;
    yq.enable = true;
    zoxide.enable = true;
    zsh.enable = true;
  };
}
