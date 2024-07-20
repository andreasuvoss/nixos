{ config, pkgs, inputs, lib, ... }:
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      #inputs.home-manager.nixosModules.default
    ];

  # NIXOS
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;



  # Screensharing and stuff + portal for gnome-keyring
  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [ 
      xdg-desktop-portal
      xdg-desktop-portal-gtk 
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-wlr
    ];
  };

  virtualisation.libvirtd.enable = true;
  virtualisation.podman.enable = true;
  programs.virt-manager.enable = true;

  networking.hostName = "argon"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = false;
  services.xserver.excludePackages = [ pkgs.xterm ]; 
  services.gnome.core-utilities.enable = false;
  services.gnome.rygel.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;

  # Gaming settings
  # https://youtu.be/qlfm3MEbqYA?si=SjIg2ab0Ka5N20Bs&t=336
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };
  programs.gamemode.enable = true;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };
  services.xserver.videoDrivers = ["amdgpu"];

  security.rtkit.enable = true;
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andreasvoss = {
    isNormalUser = true;
    description = "Andreas Voss";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
  };


  # Enable zsh
  environment.shells = with pkgs; [ zsh ];
  users.defaultUserShell = pkgs.zsh;

  programs.zsh.enable = true;
  programs.git.enable = true;

  # environment.sessionVariables = {
  #   WLR_RENDERER_ALLOW_SOFTWARE = "1";
  #   WLS_NO_HARDWARE_CURSORS = "1";
  # };

  services.spice-vdagentd.enable = true;
    
  # Install hyprland
  programs.hyprland = {
    enable = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "andreasvoss";

  # Use the decryption passphrase to also unlock the gnome-keyring
  boot.initrd.systemd.enable = true;
  security.pam.services = {
    gdm-autologin.text = ''
      auth      requisite     pam_nologin.so

      auth      required      pam_succeed_if.so uid >= 1000 quiet
      auth      optional      ${pkgs.gnome.gdm}/lib/security/pam_gdm.so
      auth      optional      ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so
      auth      required      pam_permit.so

      account   sufficient    pam_unix.so

      password  requisite     pam_unix.so nullok yescrypt

      session   optional      pam_keyinit.so revoke
      session   include       login
    '';
  };

  # While the below does work I have to input the password twice during boot, which is not what I want.
  # security.pam.services.common-password.text = ''
  #     password  optional      ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so use_authtok
  # '';
  # environment.etc.crypttab = {
  #   enable = true;
  #   text = ''
  #     cryptdata UUID=e39638af-b324-4588-91fc-5fead80aad81 none luks,keyscript=decrypt_keyctl
  #   '';
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # TODO: Modularize this

  services.gnome.gnome-keyring.enable = true;
  environment.systemPackages = with pkgs; [ home-manager mangohud libsecret ];
  services.dbus.packages = [ pkgs.gnome.seahorse ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
