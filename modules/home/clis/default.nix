{ lib, config, ... }:{
  imports = [
    ./bat
    ./curl
    ./eza
    ./fastfetch
    ./fd
    ./fzf
    ./gcc
    ./git
    ./gjs
    ./glow
    ./glunch
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
    bat.enable = true;
    btop.enable = true;
    curl.enable = true;
    eza.enable = true;
    fastfetch.enable = true;
    fd.enable = true;
    fzf.enable = true;
    git.enable = true;
    gjs.enable = true;
    glow.enable = true;
    glunch.enable = true;
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
