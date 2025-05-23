{ lib, config, ... }:{
  imports = [
    ./az-cred-provider
    ./azure-cli
    ./bat
    ./bicep
    ./curl
    ./fastfetch
    ./fd
    ./fzf
    ./gcc
    ./git
    ./gjs
    ./glow
    ./glunch
    ./gparted
    ./gum
    ./iperf
    ./btop
    ./jq
    ./keychain
    ./lazygit
    ./nodejs
    ./nvim
    ./parallel
    ./ripgrep
    ./sshfs
    ./starship
    ./stow
    ./taskwarrior
    ./timewarrior
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
    az-cred-provider.enable = false;
    azure-cli.enable = false;
    bat.enable = true;
    bicep.enable = false;
    btop.enable = true;
    curl.enable = true;
    fastfetch.enable = true;
    fd.enable = true;
    fzf.enable = true;
    git.enable = true;
    gjs.enable = true;
    glow.enable = true;
    glunch.enable = true;
    gparted.enable = false;
    gum.enable = true;
    iperf.enable = true;
    jq.enable = true;
    # keychain.enable = false;
    lazygit.enable = true;
    nodejs.enable = false;
    nvim.enable = true;
    parallel.enable = true;
    ripgrep.enable = true;
    sshfs.enable = true;
    starship.enable = true;
    stow.enable = false;
    taskwarrior.enable = true;
    timewarrior.enable = true;
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
