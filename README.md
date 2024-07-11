# NixOS dotfiles

## Installation
First we need to clone this repository, since a plain Nix installation does not contain git, we can clone the repository
by entering a Nix shell with git. You will also need this shell while building the system since flakes need git to work.

```sh
nix-shell -p git
```

Copy your hardware configuration into the host folder for the host you want to install.

```sh
cp /etc/nixos/hardware-configuration.nix ./hosts/<HOST>
```

enable flakes in the default configuration `/etc/nixos/configuration.nix` by adding the following setting and
rebuilding.

```nix
nix.settings.experimental-features = [ "nix-command" "flakes" ];
```

rebuild NixOS from the standard configuration

```sh
sudo nixos-rebuild switch
```

Now we can rebuild NixOS from the flake

```sh
sudo nixos-rebuild switch --flake .#<HOST>
```

after rebuilding the DE might crash, as we have removed it and there is currently no terminal emulator as that will be
installed by home manager. `CTRL+ALT+F1` can send you the terminal only environment from where you can run home manager

```sh
home-manager --flake .#<USER>
```

## What does this flake contain
TODO

## What is left to do?
* ~~Migrate neovim configuration from regular dotfiles to Nix Home Manager~~ ✓
* ~~Ensure full disk encryption works~~ ✓
* Get the repository ready for multi-host configurations (✓)
* `ssh-agent` and GPG - preferable with auto authentication / decryption either from Bitwarden or system login
* Secret management with `sops-nix`
* Rider with configuration and plugins
* ~~Fix XDG-portals such that the entire GNOME DE is not required for some applications to function (I'm looking at you
  Bitwarden)~~ ✓
* Pack Azure Artifacts Credential Provider (https://github.com/microsoft/artifacts-credprovider)
* Pack Azure-CLI plugin app-insights

## Adding Windows 11 to systemd-boot menu
1. Identify the Windows boot partition using `sudo blkid | grep vfat` or `lsbkl`. In my case the partition was 100M in
   size 
2. Mount the Windows boot partition to a directory `sudo mount /dev/nvme1n1p1 win-boot` change the partition to match
   the one found in the previous step.
3. Copy `win-boot/EFI/Mircosoft` into `/boot/EFI` by going to the `win-boot/EFI` directory and running
   `sudo cp -r Microsoft /boot/EFI`
4. Done! Clean up by runninng `sudo umount win-boot/EFI`.

## Secure boot
If I find the time I might have a look at this article going through how to enabled secure boot with full disk
encryption.

https://jnsgr.uk/2024/04/nixos-secure-boot-tpm-fde/

## Troubleshooting

### `sway-audio-idle-inhibit` crashes after monitor standby
If my monitor goes into standby mode, `sway-audio-idle-inhibit` crashes the next time sound is played. To combat this,
I am starting it as a service, such that whenever it crashes is quickly starts up again, so I wont get frustrated while
watching videos, having to move my mouse every 180 seconds.

The standby / disconnect of a monitor also makes Hyprland go to an empty workspace when the monitor wakes back up.

