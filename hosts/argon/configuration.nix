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
    inputs.sops-nix.nixosModules.sops
  ];
  # NixOS
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/home/andreasvoss/.config/sops/age/keys.txt";

  sops.secrets."restic/key" = {
    owner = config.users.users.andreasvoss.name;
  };

  sops.secrets."restic/repo" = {
    owner = config.users.users.andreasvoss.name;
  };

  # Allow unfree (non open source) packages
  nixpkgs.config.allowUnfree = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andreasvoss = {
    isNormalUser = true;
    description = "Andreas Voss";
    extraGroups = [
      "networkmanager"
      "wheel"
      "libvirtd"
      "docker"
    ];
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # TODO: Throw in gnome-keyring if not enabled
  # boot.initrd.systemd.enable = true;

  # Dynamic linkers
  # TODO: Might try to get this to work later
  programs.nix-ld.enable = true;
  # programs.nix-ld.libraries = with pkgs; [
  #   icu
  # ];
  environment.sessionVariables = {
    RESTIC_PASSWORD_FILE = "/run/secrets/restic-key";
    RESTIC_REPOSITORY_FILE = "/run/secrets/restic-repos/argon";
  };

  # Enables the desktop module
  desktop.enable = true;

  # Enables virtualization
  virtualization.enable = true;

  # Network configuration
  networking.hostName = "argon"; # Define your hostname.
  networking.networkmanager.enable = true;
  networking.firewall.allowedTCPPorts = [
    22000 # Syncthing
  ];
  networking.firewall.allowedUDPPorts = [
    5353 # Spotify discovery
    22000 # Syncthing
  ];

  # networking.useNetworkd = true;
  # systemd.network = {
  #   enable = true;
  #   networks."50-wg0" = {
  #     matchConfig.Name = "wg0";
  #     address = [
  #       # "fd31:bf08:57cb::7/128"
  #       "10.10.10.2/24"
  #     ];
  #   };
  #   netdevs."50-wg0" = {
  #     netdevConfig = {
  #       Kind = "wireguard";
  #       Name = "wg0";
  #     };
  #     wireguardConfig = {
  #       ListenPort = 51820;
  #       PrivateKeyFile = config.sops.secrets.wg-private-key.path;
  #       RouteTable = "main";
  #       FirewallMark = 42;
  #     };
  #     wireguardPeers = [
  #       {
  #         # argon ?
  #         Endpoint = "45.132.247.48:51820";
  #         PublicKey = "kBZXeldBYFIn+3lCYdMHkv2KgYPKN0L/0yXmYeY5UGE=";
  #         AllowedIPs = [ "10.10.10.0/0" ];
  #         PersistentKeepalive = 25;
  #       }
  #     ];
  #
  #   };
  # };

  # The configuration below might be needed for accessing the network on VMs
  # networking.interfaces.enp8s0.useDHCP = true;
  # networking.interfaces.br0.useDHCP = true;
  # networking.bridges = {
  #   "br0" = {
  #     interfaces = [ "enp8s0" ];
  #   };
  # };

  # Enable gaming
  gaming.enable = true;

  # Enable sound
  sound-config.enable = true;

  services.pipewire.wireplumber.extraConfig."10-audio-renames"."monitor.alsa.rules" = [
    {
      matches = [
        {
          "node.name" = "alsa_output.usb-Blue_Microphones_Yeti_Stereo_Microphone_REV8-00.analog-stereo";
        }
        {
          "node.name" = "alsa_input.pci-0000_18_00.6.analog-stereo";
        }
      ];
      actions.update-props = {
        "node.disabled" = true;
      };
    }

    {
      matches = [
        {
          "node.name" = "alsa_output.pci-0000_03_00.1.hdmi-stereo";
        }
      ];
      actions.update-props = {
        "node.description" = "DisplayPort";
        "node.nick" = "DisplayPort";
      };
    }
    {
      matches = [
        {
          "node.name" = "alsa_output.pci-0000_18_00.6.analog-stereo";
        }
      ];
      actions.update-props = {
        "node.description" = "Analog Stereo";
        "node.nick" = "Analog Stereo";
      };
    }
    {
      matches = [
        {
          "node.name" = "alsa_input.usb-Blue_Microphones_Yeti_Stereo_Microphone_REV8-00.analog-stereo";
        }
      ];
      actions.update-props = {
        "node.description" = "Yeti Blue";
        "node.nick" = "Yeti Blue";
      };
    }
  ];

  # Enable the gnome-keyring for Hyprland with auto unlock from decryption passphrase
  # gnome-keyring.enable = false; # now part of desktop

  # TODO: Make this configurable later for different hosts
  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      teams = {
        executable = "${pkgs.teams-for-linux}/bin/teams-for-linux";
      };
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}