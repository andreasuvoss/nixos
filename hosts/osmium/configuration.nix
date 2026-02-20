{ config, pkgs, inputs, lib, ... }: {
  imports =
    [
      ./hardware-configuration.nix
      # ./compose.nix
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

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDTDEi9qjl+MWFW53lLn280+DXvnEUfmoQd2IdR6GQoTQNnb0vrEUaDqPF1M1TNMa3zTj4zN5+SpTcKE69FKlrVW7jBoSN82g/6gc3tb8j2QXjYkKh6/fqIWQdMKvM1DsK7O5g3rFdQbUN+sb3RovZvns4wsZJCMsZFASkBJnYbQ5GZ2fYtxFk75JjRWm4kroByu/tka5wmO9K9oIzH2/D1/9Se3NbAZtxjAUyjtE5GY2yU3LYbfdG+VvlSuyVE9JDuk2Cepls5HFwXmoYn4NAwd7izuOwCsc95bdSw0Ju3t1TDeCxo7YSTx0hxkjVt0xi6mZZThyvAhXzUCUBxUhET andreasvoss@argon"
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enables virtualization
  virtualization.enable = true;

  # systemd.services.podman-home-assistant.serviceConfig.User = "andreasvoss";
  # systemd.services.podman-pihole.serviceConfig.User = "andreasvoss";
  # virtualisation.podman = {
  #   enable = true;
  #   autoPrune.enable = true;
  #   # dockerCompat = true;
  #   defaultNetwork.settings = {
  #     dns_enabled = true;
  #   };
  # };
  #
  # networking.firewall.interfaces."podman+".allowedUDPPorts = [ 53 ];

  virtualisation.oci-containers = {
    backend = "podman";
    containers = {
      home-assistant = {
        image = "homeassistant/home-assistant:2026.2.2";
        volumes = [
          "/home/andreasvoss/apps/homeassistant:/config"
        ];
        ports = [
          "8123:8123"
        ];
        extraOptions = [
          "--network=host"
          "--cap-add=CAP_NET_RAW"
        ];
      };
      syncthing = {
        image = "docker.io/syncthing/syncthing:2.0.14";
        volumes = [
          "/home/andreasvoss/apps/syncthing/config:/config"
          "/home/andreasvoss/apps/syncthing/data:/data"
        ];
        ports = [
          "8384:8384"
          "22000:22000/tcp"
          "22000:22000/udp"
          "21027:21027/udp"
        ];
        extraOptions = [
          "--network=host"
        ];
        environment = {
          TZ = "Etc/UTC";
          PUID = "1000";
          PGID = "1000";
        };
      };
      pihole = {
        image = "pihole/pihole:2026.02.0";
        volumes = [
          "/home/andreasvoss/apps/pihole/pihole:/etc/pihole"
          "/home/andreasvoss/apps/pihole/dnsmasq.d:/etc/dnsmasq.d"
        ];
        ports = [
          "53:53/tcp"
          "53:53/udp"
          "8010:80/tcp"
        ];
        environment = {
          TZ = "Europe/Copenhagen";
          FTLCONF_webserver_api_password = "";
        };
        # extraOptions = [
        # ];
      };
      # The network needs to be created manually for now
      mqtt = {
        image = "docker.io/library/eclipse-mosquitto:2.0";
        volumes = [
          "/home/andreasvoss/apps/mosquitto-data:/mosquitto"
        ];
        # ports = [
        #   "1883:1883"
        #   "9001:9001"
        # ];
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
        image = "docker.io/koenkk/zigbee2mqtt:2.8.0";
        volumes = [
          "/home/andreasvoss/apps/zigbee2mqtt-data:/app/data"
          "/run/udev:/run/udev:ro"
        ];
        # ports = [
        #   "8081:8081"
        # ];
        environment = {
          TZ = "Europe/Copenhagen";
        };
        extraOptions = [
          "--pod=mqtt"
          "--device=/dev/ttyUSB0"
        ];
      };
    };

  };

  # Create a pod for mqtt and zigbee2mqtt
  systemd.services.create-mqtt-pod = with config.virtualisation.oci-containers; {
    serviceConfig.Type = "oneshot";
    wantedBy = [ "${backend}-mqtt.service" ];
    script = ''
      ${pkgs.podman}/bin/podman pod exists mqtt || \
        ${pkgs.podman}/bin/podman pod create -n mqtt -p '0.0.0.0:8081:8081' -p '0.0.0.0:1883:1883'
    '';
  };

  # Network configuration
  networking.hostName = "osmium";
  networking.firewall.allowedTCPPorts = [ 8123 1400 53 8010 5201 8080 8081 1883 8284 22000 ];
  networking.firewall.allowedUDPPorts = [ 1900 5353 53 5201 8080 8081 1883 8284 22000 21027 ];
  #networking.firewall.enable = false;

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