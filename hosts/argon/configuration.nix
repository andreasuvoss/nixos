{ config, pkgs, inputs, lib, ... }: {
  imports =
    [ 
      ./hardware-configuration.nix
      ../../modules/nixos
    ];

  # NixOS
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Allow unfree (non open source) packages
  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andreasvoss = {
    isNormalUser = true;
    description = "Andreas Voss";
    extraGroups = [ "networkmanager" "wheel" "libvirtd" ];
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # TODO: Throw in gnome-keyring if not enabled
  # boot.initrd.systemd.enable = true;

  # Enables the desktop module
  desktop.enable = true;

  # Enables virtualization
  virtualization.enable = true;

  # Network configuration
  networking.hostName = "argon"; # Define your hostname.
  networking.networkmanager.enable = true;

  # Enable gaming
  gaming.enable = true;

  # Enable sound
  sound-config.enable = true;

  # Enable the gnome-keyring for Hyprland with auto unlock from decryption passphrase
  gnome-keyring.enable = true;

  # Enable network shares
  network-shares.enable = true;



  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
