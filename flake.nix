{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
    nixpkgs-master.url = "github:nixos/nixpkgs/master";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main"; 
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixpkgs-unstable, nixpkgs-master, nixos-wsl, ... }@inputs:
  let
    lib = nixpkgs.lib;
    user = "andreasvoss";
    system = "x86_64-linux";
    # nixpkgs-patched = (import nixpkgs { inherit system; }).applyPatches {
    #   name = "nixos-nixpkgs-316386";
    #   src = nixpkgs;
    #   patches = [ ./modules/home/clis/misc-tools/nixos-nixpkgs-316386.patch ];
    # };
    pkgs = import nixpkgs { inherit system; };
  in {
    nixosConfigurations = {
      argon-vm = nixpkgs.lib.nixosSystem {
        inherit system;
          modules = [
            ./hosts/argon-vm/configuration.nix
            ./modules/nixos/locale.nix
          ];
      };
      argon = nixpkgs.lib.nixosSystem {
        inherit system;
          modules = [
            ./hosts/argon/configuration.nix
            ./modules/nixos/locale.nix
          ];
      };
      wsl = nixpkgs.lib.nixosSystem {
        inherit system;
          modules = [
             nixos-wsl.nixosModules.wsl
            ./hosts/wsl/configuration.nix
          ];
      };
    };
    homeConfigurations = {
      andreasvoss = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        extraSpecialArgs = { 
          pkgs-unstable = import nixpkgs-unstable {
            config.allowUnfree = true;
            inherit system;
          };
          pkgs-master = import nixpkgs-master {
            config.allowUnfree = true;
            inherit system;
          };
          inherit inputs;
        };
	      modules = [ 
          ./hosts/argon/home.nix
        ];
      };

      nixos = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
	    modules = [ 
          ./hosts/wsl/home.nix
        ];
        extraSpecialArgs = { 
          pkgs-unstable = import nixpkgs-unstable {
            config.allowUnfree = true;
            inherit system;
          };
          pkgs-master = import nixpkgs-master {
            config.allowUnfree = true;
            inherit system;
          };
          inherit inputs;
        };
      };
    };
  };
}
