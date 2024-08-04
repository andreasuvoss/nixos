{ lib, config, ...}:
{
  options = {
    git.enable = lib.mkEnableOption "enable git";
    git.signingkey = lib.mkOption {
      type = lib.types.str;
      default = "id_rsa.pub";
      description = "Name of the public signing key for git";
    };
  };
  config = lib.mkIf config.git.enable {
    programs.git = {
      enable = true;  
      userName = "Andreas Voss";
      userEmail = "andreas@anvo.dk";
      extraConfig = {
        push.autoSetupRemote = true;
        user.signingkey = "~/.ssh/${config.git.signingkey}";
        gpg.format = "ssh";
        commit.gpgsign = true;
        rerere.enabled = true;
      };
    };
  };
}
