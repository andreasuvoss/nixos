{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
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
      ags,
      ...
    }@inputs:
    let
      lib = nixpkgs.lib;
      user = "andreasvoss";
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      nixosConfigurations = {
        argon = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/argon/configuration.nix ];
        };
        osmium = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/osmium/configuration.nix ];
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
      };
    };
}
