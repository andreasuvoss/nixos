{...}:
{
  programs.git = {
    enable = true;  
    userName = "Andreas Voss";
    userEmail = "andreas@anvo.dk";
    extraConfig = {
      push.autoSetupRemote = true;
      user.signingkey = "/home/andreasvoss/.ssh/id_rsa.pub";
      gpg.format = "ssh";
      # TODO: GPG Signing
    };
  };
}
