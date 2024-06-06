{...}:
{
  programs.git = {
    enable = true;  
    userName = "Andreas Voss";
    userEmail = "andreas@anvo.dk";
    extraConfig = {
      push.autoSetupRemote = true;
      # TODO: GPG Signing
    };
  };
}
