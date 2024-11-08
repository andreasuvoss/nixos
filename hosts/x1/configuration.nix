{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
  ];

  # NixOS
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Allow unfree (non open source) packages
  nixpkgs.config.allowUnfree = true;

  programs.nix-ld.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = 1;
  };

  environment.systemPackages = with pkgs; [
    modemmanager
    libmbim
  ];

  systemd.services.modem-manager = {
    description = "Modem Manager";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.modemmanager}/bin/ModemManager";
      Restart = "always";
    };
  };

  services.logind.lidSwitchExternalPower= "ignore";
  services.logind.lidSwitch = "suspend";
  services.logind.lidSwitchDocked = "ignore";

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${pkgs.coreutils}/bin/chmod a+w /sys/class/backlight/%k/brightness"
  '';

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andreasvoss = {
    isNormalUser = true;
    description = "Andreas Voss";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "video"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTDEi9qjl+MWFW53lLn280+DXvnEUfmoQd2IdR6GQoTQNnb0vrEUaDqPF1M1TNMa3zTj4zN5+SpTcKE69FKlrVW7jBoSN82g/6gc3tb8j2QXjYkKh6/fqIWQdMKvM1DsK7O5g3rFdQbUN+sb3RovZvns4wsZJCMsZFASkBJnYbQ5GZ2fYtxFk75JjRWm4kroByu/tka5wmO9K9oIzH2/D1/9Se3NbAZtxjAUyjtE5GY2yU3LYbfdG+VvlSuyVE9JDuk2Cepls5HFwXmoYn4NAwd7izuOwCsc95bdSw0Ju3t1TDeCxo7YSTx0hxkjVt0xi6mZZThyvAhXzUCUBxUhET andreasvoss@argon"
    ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      teams = {
        executable = "${pkgs.teams-for-linux}/bin/teams-for-linux";
      };
    };
  };

  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.KbdInteractiveAuthentication = false;

  # Enables the desktop module
  desktop.enable = true;

  # Enables virtualization
  virtualization.enable = true;

  # Network configuration
  networking.hostName = "x1"; # Define your hostname.
  networking.networkmanager.enable = true;
  # networking.networkmanager.fccUnlockScripts = [
  #   { id = "1eac:100d"; path = "${pkgs.lenovo-wwan-unlock}/bin/fcc_unlock.sh"; }
  # ];

  # Enable gaming
  gaming.enable = false;

  # Enable sound
  sound-config.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}
