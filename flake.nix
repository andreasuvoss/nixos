{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.05";
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

  outputs =
    {
      nixpkgs,
      home-manager,
      nixpkgs-unstable,
      nixos-wsl,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      user = "andreasvoss";
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
    in
    {
      devShells."x86_64-linux".default = pkgs.mkShell {
        packages = [
          pkgs.netcoredbg
          # pkgs.dotnetCorePackages.sdk_8_0_2xx
          (with pkgs.dotnetCorePackages; combinePackages [
            sdk_7_0_3xx
            sdk_8_0_2xx
            sdk_9_0 
          ])
       ];
      };
      nixosConfigurations = {
        argon-vm = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/argon-vm/configuration.nix ];
        };
        argon = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/argon/configuration.nix ];
        };
        osmium = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/osmium/configuration.nix ];
        };
        wsl = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            nixos-wsl.nixosModules.wsl
            ./hosts/wsl/configuration.nix
          ];
        };
        x1 = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/x1/configuration.nix ];
        };
      };
      homeConfigurations = {
        "andreasvoss@argon" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            pkgs-unstable = import nixpkgs-unstable {
              config.allowUnfree = true;
              inherit system;
            };
            inherit inputs;
          };
          modules = [ ./hosts/argon/home.nix ];
        };

        "andreasvoss@x1" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            pkgs-unstable = import nixpkgs-unstable {
              config.allowUnfree = true;
              inherit system;
            };
            inherit inputs;
          };
          modules = [ ./hosts/x1/home.nix ];
        };

        "andreasvoss@osmium" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            pkgs-unstable = import nixpkgs-unstable {
              config.allowUnfree = true;
              inherit system;
            };
            inherit inputs;
          };
          modules = [ ./hosts/osmium/home.nix ];
        };

        nixos = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            pkgs-unstable = import nixpkgs-unstable {
              config.allowUnfree = true;
              inherit system;
            };
            inherit inputs;
          };
          modules = [ ./hosts/wsl/home.nix ];
        };
      };
    };
}
