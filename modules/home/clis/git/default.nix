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
    programs.delta = {
      enable = true;
      enableGitIntegration = true;
    };

    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Andreas Voss";
          email = "andreas@anvo.dk";
          push.autoSetupRemote = true;
          user.signingkey = "~/.ssh/${config.git.signingkey}";
          gpg.format = "ssh";
          commit.gpgsign = true;
          rerere.enabled = true;
          delta.line-numbers = true;
          delta.side-by-side = true;
        };
      };
    };
  };
}