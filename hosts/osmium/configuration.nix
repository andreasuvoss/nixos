{
  config,
  pkgs,
  inputs,
  lib,
  ...
}:
let
  pihole-image = "docker.io/pihole/pihole:2026.05.0"; # https://hub.docker.com/r/pihole/pihole/tags
  homeassistant-image = "docker.io/homeassistant/home-assistant:2026.6.2";
  mosquitto-image = "docker.io/library/eclipse-mosquitto:2.1.2-alpine";
  syncthing-image = "docker.io/syncthing/syncthing:2.1.1";
  zigbee2mqtt-image = "docker.io/koenkk/zigbee2mqtt:2.12.0";
  filebrowser-image = "docker.io/gtstef/filebrowser:1.3.3-stable";
in
{

  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos
    inputs.sops-nix.nixosModules.sops
  ];

  disabledModules = [
    "virtualisation/oci-containers.nix"
  ];

  # NixOS
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  sops.defaultSopsFile = ../../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.keyFile = "/home/podman/.config/sops/age/keys.txt";

  sops.secrets.restic-key = {
    owner = config.users.users.podman.name;
  };

  sops.secrets."restic-repos/osmium" = {
    owner = config.users.users.podman.name;
  };

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

  # users.users.root.openssh.authorizedKeys.keys = [
  #   "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTDEi9qjl+MWFW53lLn280+DXvnEUfmoQd2IdR6GQoTQNnb0vrEUaDqPF1M1TNMa3zTj4zN5+SpTcKE69FKlrVW7jBoSN82g/6gc3tb8j2QXjYkKh6/fqIWQdMKvM1DsK7O5g3rFdQbUN+sb3RovZvns4wsZJCMsZFASkBJnYbQ5GZ2fYtxFk75JjRWm4kroByu/tka5wmO9K9oIzH2/D1/9Se3NbAZtxjAUyjtE5GY2yU3LYbfdG+VvlSuyVE9JDuk2Cepls5HFwXmoYn4NAwd7izuOwCsc95bdSw0Ju3t1TDeCxo7YSTx0hxkjVt0xi6mZZThyvAhXzUCUBxUhET andreasvoss@argon"
  # ];

  users.groups.podman = {
    gid = 994;
  };

  users.users.podman = {
    uid = 993;
    group = "podman";
    extraGroups = [ "dialout" ];
    linger = true;
    autoSubUidGidRange = true;
    isSystemUser = true;
    createHome = true;
    home = "/home/podman";
  };

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.caddy = {
    enable = true;
    virtualHosts."test.osmium.local".extraConfig = ''
      respond "testing..."
      tls internal
    '';
    virtualHosts."files.osmium.local".extraConfig = ''
      reverse_proxy 127.0.0.1:4321
      tls internal
    '';
    virtualHosts."ha.osmium.local".extraConfig = ''
      reverse_proxy 127.0.0.1:8123
      tls internal
    '';
    virtualHosts."pihole.osmium.local".extraConfig = ''
      reverse_proxy 127.0.0.1:8010
      tls internal
    '';
    virtualHosts."sync.osmium.local".extraConfig = ''
      reverse_proxy 127.0.0.1:8384
      tls internal
    '';
    virtualHosts."z2m.osmium.local".extraConfig = ''
      reverse_proxy 127.0.0.1:8081
      tls internal
    '';
  };

  # Enables virtualization
  virtualization.enable = true;

  virtualisation.oci-containers = with config.users; {
    backend = "podman";
    containers = {
      home-assistant = {
        image = homeassistant-image;
        podman.user = "podman";
        volumes = [
          "/home/podman/apps/homeassistant:/config"
        ];
        ports = [
          "127.0.0.1:8123:8123"
        ];
        extraOptions = [
          "--network=host"
        ];
      };
      filebrowser = {
        image = filebrowser-image;
        podman.user = "podman";
        ports = [
          "127.0.0.1:4321:80"
        ];
        extraOptions = [
          "--userns=keep-id"
          "--cap-add=NET_BIND_SERVICE"
        ];
        user = "${builtins.toString users.podman.uid}:${builtins.toString groups.podman.gid}";
        environment = {
          FILEBROWSER_DATABASE = "/db/database.db";
        };
        volumes = [
          "/home/podman/apps/filebrowser/data:/home/filebrowser/data"
          "/home/podman/apps/filebrowser/db:/db"
          "/home/podman/apps/syncthing/data/quantum:/default"
        ];
      };
      syncthing = {
        image = syncthing-image;
        podman.user = "podman";
        volumes = [
          "/home/podman/apps/syncthing/config:/var/syncthing/config"
          "/home/podman/apps/syncthing/data:/data"
        ];
        ports = [
          "127.0.0.1:8384:8384"
          "22000:22000/tcp"
          "22000:22000/udp"
          "21027:21027/udp"
        ];
        extraOptions = [
          "--userns=keep-id"
        ];
        environment = {
          TZ = "Etc/UTC";
          PUID = "${builtins.toString users.podman.uid}";
          PGID = "${builtins.toString groups.podman.gid}";
        };
      };
      pihole = {
        image = pihole-image;
        podman.user = "podman";
        volumes = [
          "/home/podman/apps/pihole/pihole:/etc/pihole"
          "/home/podman/apps/_backups/pihole:/etc/pihole-backup"
        ];
        ports = [
          "5300:53/tcp"
          "5300:53/udp"
          "127.0.0.1:8010:80/tcp"
        ];
        environment = {
          TZ = "Europe/Copenhagen";
          FTLCONF_webserver_domain = "pihole.osmium.local";
          FTLCONF_webserver_api_password = "";
        };
      };
      mqtt = {
        image = mosquitto-image;
        podman.user = "podman";
        volumes = [
          "/home/podman/apps/mosquitto-data:/mosquitto"
        ];
        cmd = [
          "mosquitto"
          "-c"
          "/mosquitto-no-auth.conf"
        ];
        extraOptions = [
          "--pod=mqtt"
        ];
      };

      zigbee2mqtt = {
        image = zigbee2mqtt-image;
        podman.user = "podman";
        volumes = [
          "/home/podman/apps/zigbee2mqtt-data:/app/data"
          "/run/udev:/run/udev:ro"
        ];
        environment = {
          TZ = "Europe/Copenhagen";
        };
        extraOptions = [
          "--pod=mqtt"
          "--device=/dev/ttyUSB0"
          "--group-add=keep-groups"
        ];
      };
    };

  };

  systemd.services.create-mqtt-pod-rootless = with config.virtualisation.oci-containers; {
    serviceConfig.Type = "oneshot";
    serviceConfig.User = "podman";
    wantedBy = [ "${backend}-mqtt.service" ];
    script = ''
      ${pkgs.podman}/bin/podman pod exists mqtt || \
        ${pkgs.podman}/bin/podman pod create --userns=keep-id -n mqtt -p '127.0.0.1:8081:8081' -p '127.0.0.1:1883:1883'
    '';
  };

  systemd.timers."pihole-teleporter" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "Mon *-*-1..7 3:00:00";
      Persistent = true;
      Unit = "pihole-teleporter.service";
    };
  };

  systemd.services."pihole-teleporter" = {
    script = ''
      set -eu
      ${pkgs.podman}/bin/podman exec --workdir /etc/pihole-backup pihole pihole-FTL --teleporter
    '';
    restartIfChanged = false;
    serviceConfig = {
      Type = "oneshot";
      User = "podman";
    };
  };

  systemd.timers."backup" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 4:00:00";
      Persistent = true;
      Unit = "backup.service";
    };
  };

  systemd.services."backup" = {
    path = [ pkgs.openssh pkgs.restic ];
    script = ''
      set -eu
      ${pkgs.restic}/bin/restic backup /home/podman/apps \
        --tag daily,automatic \
        --exclude /home/podman/apps/pihole\
        --repository-file /run/secrets/restic-repos/osmium \
        --password-file /run/secrets/restic-key
    '';
    restartIfChanged = false;
    serviceConfig = {
      Type = "oneshot";
      User = "podman";
    };
  };

  # Network configuration
  networking.hostName = "osmium";
  networking.firewall.allowedTCPPorts = [
    53      # DNS
    80      # HTTP
    443     # HTTPS
    1400    # Sonos
    5300    # DNS (redirect)
    22000   # Syncthing
  ];
  networking.firewall.allowedUDPPorts = [
    53        # DNS
    80        # HTTP
    443       # HTTPS
    5300      # DNS (redirect)
    5353      # mDNS (plug-and-play - Sonos Home Assistant)
    22000     # Syncthing
    21027     # Syncthing
  ];

  networking.nftables.enable = true;
  # Local portforwading due to Pihole running as a rootless container
  networking.nftables.ruleset = ''
    table inet nat {
      chain prerouting {
        type nat hook prerouting priority -100; policy accept;
        udp dport 53 redirect to :5300
        tcp dport 53 redirect to :5300
      }
    }
  '';

  #networking.firewall.enable = false;
  boot.kernel.sysctl = {
    "net.ipv4.conf.eth0.forwarding" = 1; # enable port forwarding
  };

  # Enable the OpenSSH deamon
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;
  services.openssh.settings.KbdInteractiveAuthentication = false;

  programs.ssh.kexAlgorithms = config.services.openssh.settings.KexAlgorithms;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?
}