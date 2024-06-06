{ pkgs, lib, ... }:{
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    ffmpeg
    pavucontrol

    # FONTS
    google-fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    # proggyfonts
    (nerdfonts.override { fonts = [ "JetBrainsMono" ] ; })
  ];
  # imports = lib.filesystem.listFilesRecursive ;
  imports = [
    ./dconf
    ./gtk
    ./hyprland
    ./nemo
    ./waybar
    ./screenshot
    ./swayidle
    ./swaylock
    ./swaybg
    ./swaync
    ./wlogout
  ];
}
