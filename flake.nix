{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main"; 
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixos-wsl, ... }@inputs:
  let
    lib = nixpkgs.lib;
    user = "andreasvoss";
    system = "x86_64-linux";
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
        extraSpecialArgs = { inherit inputs; };
	    modules = [ 
          ./home.nix
          ./modules/home
        ];
      };
      nixos = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        # extraSpecialArgs = { inherit inputs; };
	    modules = [ 
          ./hosts/wsl/home.nix
        ];
      };
    };
  };
}
