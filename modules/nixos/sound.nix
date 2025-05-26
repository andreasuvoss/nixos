{ pkgs, lib, config, ... }: {
  options = {
    sound-config.enable = lib.mkEnableOption "enables sound-config";
  };
  config = lib.mkIf config.sound-config.enable {
    # TODO: Why is this disabled?
    # Enable sound with pipewire.
    security.rtkit.enable = true;
    services.pulseaudio.enable = false;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };
  };
}
