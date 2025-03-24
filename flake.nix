{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:aylur/ags";
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixpkgs-unstable,
      nixos-wsl,
      ags,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      user = "andreasvoss";
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config.permittedInsecurePackages = [ "dotnet-sdk-7.0.410" ];
      };
    in
    {
      # packages.${system}.default = ags.lib.bundle {
      #   inherit pkgs;
      #   src = ./.;
      #   name = "my-shell";
      #   entry = "app.ts";
      #   gtk4 = false;
      #   extraPackages = [
      #   ];
      # };
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
              config.permittedInsecurePackages = [ "dotnet-sdk-7.0.410" ];
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
              config.permittedInsecurePackages = [ "dotnet-sdk-7.0.410" ];
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
