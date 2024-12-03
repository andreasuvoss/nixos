{ pkgs, lib, config, ... }:{
  options = {
    fonts.enable = lib.mkEnableOption "enables fonts";
  };
  config = lib.mkIf config.fonts.enable {
    fonts.fontconfig.enable = true;
    home.packages = with pkgs; [
      google-fonts
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      (nerdfonts.override { fonts = [ "JetBrainsMono" ] ; })
    ];
  };
}
