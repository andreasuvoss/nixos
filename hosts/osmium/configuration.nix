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
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTDEi9qjl+MWFW53lLn280+DXvnEUfmoQd2IdR6GQoTQNnb0vrEUaDqPF1M1TNMa3zTj4zN5+SpTcKE69FKlrVW7jBoSN82g/6gc3tb8j2QXjYkKh6/fqIWQdMKvM1DsK7O5g3rFdQbUN+sb3RovZvns4wsZJCMsZFASkBJnYbQ5GZ2fYtxFk75JjRWm4kroByu/tka5wmO9K9oIzH2/D1/9Se3NbAZtxjAUyjtE5GY2yU3LYbfdG+VvlSuyVE9JDuk2Cepls5HFwXmoYn4NAwd7izuOwCsc95bdSw0Ju3t1TDeCxo7YSTx0hxkjVt0xi6mZZThyvAhXzUCUBxUhET andreasvoss@argon"
    ];
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.initrd.systemd.enable = true;

  # Enables the desktop module
  desktop.enable = false;

  # Enables virtualization
  virtualization.enable = true;

  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      home-assistant = {
        image = "homeassistant/home-assistant:latest";
        volumes = [
          "/home/andreasvoss/apps/home-assistant:/config"
        ];
        ports = [
          "8123:8123"
        ];
        extraOptions = [
          "--network=host"  
          # "--device=/dev/ttyACM0" #conbee goes here
        ];
      };
    };
  };

  # Network configuration
  networking.hostName = "osmium";

  # Enable the OpenSSH deamon
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.KbdInteractiveAuthentication = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
