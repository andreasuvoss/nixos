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

## Generations
When working on NixOS it can take a few generations to get it right. To list all NixOS generation the following command 
can be run as sudo

```sh
sudo nix-env --profile /nix/var/nix/profiles/system --list-generation
```

other flags can be passed to clean out the older generations. In case you do not pass a profile the home manager
generations will be listed

```sh
nix-env --list-generation
```

<!-- ### Rolling back to a previous generation -->


## What is left to do?
* ~~Migrate neovim configuration from regular dotfiles to Nix Home Manager~~ ✓
* ~~Ensure full disk encryption works~~ ✓
* ~~Get the repository ready for multi-host configurations~~ ✓
* ~~`ssh-agent` and GPG - preferable with auto authentication / decryption either from Bitwarden or system login~~ ✓
* Secret management with `sops-nix`
* Rider with configuration and plugins
* ~~Fix XDG-portals such that the entire GNOME DE is not required for some applications to function (I'm looking at you
  Bitwarden)~~ ✓
* ~~Pack Azure Artifacts Credential Provider (https://github.com/microsoft/artifacts-credprovider)~~ ✓
* ~~Pack Azure-CLI plugin app-insights~~ ✓

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

### `bicep` with the `az` CLI
When trying to deploy a `.bicep` file without any extra configuration, the error

```
Could not start dynamically linked executable: /home/<USER>/.azure/bin/bicep
NixOS cannot run dynamically linked executables intended for generic
linux environments out of the box. For more information, see:
https://nix.dev/permalink/stub-ld
```
will most likely pop up. To work around this set the Azure config to use Bicep from path:

```sh
az config set bicep.use_binary_from_path=True
```

This could be part of my configuration, but I will work on this some other day I reckon

# Quick todo

- Get jumping plugin for nvim
- d+i + (/{ is pretty cool

# Clean profiles

```sh
sudo ~/.scripts/clean-profiles.sh "+2"
```

# Connect to WIFI with `nmcli`

```sh
nmcli device wifi connect <APname> password <password>
```

# Make the WWAN interface work (for X1 Carbon)
I spent some time trying to get auto fcc unlock to work, but I do not want to invest more time in that now, since I
rarely use it, so as long as I have documented how I can connect that is fine. [This repo](https://github.com/lenovo/lenovo-wwan-unlock) might be useful in the future if I want to automate it.

```sh
# Create the connection
nmcli connection add type gsm ifname wwan0mbim0 con-name "tdc-modem" apn internet

# Unlock the radio (I guess, I don't really know)
sudo mbimcli -p -d /dev/wwan0mbim0 -v --quectel-set-radio-state=on

# Connect
nmcli c up tdc-modem --ask
```
