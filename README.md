# NixOS dotfiles

## Installation
Copy your hardware configuration into the host folder for the host you want to install.

```sh
cp /etc/nixos/hardware-configuration.nix ./hosts/<HOST>
```

enable flakes temporarily (they will be enabled permanently after the OS has been rebuilt).

```sh
nix --experimental-features 'nix-command flakes'
```

Rebuild NixOS

```sh
sudo nixos-rebuild switch --flake .#<HOST>
```

Rebuild Home Manager

```sh
home-manager --flake .#<USER>
```

## What does this flake contain
TODO

## What is left to do?
* Migrate neovim configuration from regular dotfiles to Nix Home Manager
* Ensure full disk encryption works
* Get the repository ready for multi-host configurations
* `ssh-agent` and GPG - preferable with auto authentication / decryption either from Bitwarden or system login
* Secret management with `sops-nix`
* Rider with configuration and plugins

## Adding Windows 11 to systemd-boot menu
1. Identify the Windows boot partition using `sudo blkid | grep vfat` or `lsbkl`. In my case the partition was 100M in
   size 
2. Mount the Windows boot partition to a directory `sudo mount /dev/nvme1n1p1 win-boot` change the partition to match
   the one found in the previous step.
3. Copy `win-boot/EFI/Mircosoft` into `/boot/EFI` by going to the `win-boot/EFI` directory and running
   `sudo cp -r Microsoft /boot/EFI`
4. Done! Clean up by runninng `sudo umount win-boot/EFI`.

## Secure boot
I probably wont do secure boot at this point, as it is not supported without jumping through a lot of hoops.

## Troubleshooting

### `sway-audio-idle-inhibit` crashes after monitor standby
If my monitor goes into standby mode, `sway-audio-idle-inhibit` crashes the next time sound is played. To combat this,
I am starting it as a service, such that whenever it crashes is quickly starts up again, so I wont get frustrated while
watching videos, having to move my mouse every 180 seconds.

The standby / disconnect of a monitor also makes Hyprland go to an empty workspace when the monitor wakes back up.

