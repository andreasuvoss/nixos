{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/release-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    gtk-shell.url = "git+ssh://git@github.com/andreasuvoss/gtk-shell.git?ref=ags3";
    glunch.url = "github:andreasuvoss/glunch";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    ags = {
      url = "github:aylur/ags";
    };
    nvim-autotag = {
      url = "github:windwp/nvim-ts-autotag";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      home-manager,
      nixpkgs-unstable,
      ags,
      gtk-shell,
      glunch,
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
          specialArgs = {
            pkgs-unstable = import nixpkgs-unstable {
              config.allowUnfree = true;
              inherit system;
            };
          };
          modules = [ ./hosts/argon/configuration.nix ];
        };
        osmium = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            pkgs-unstable = import nixpkgs-unstable {
              config.allowUnfree = true;
              inherit system;
            };
          };
          modules = [ ./hosts/osmium/configuration.nix ];
        };
        x1 = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            pkgs-unstable = import nixpkgs-unstable {
              config.allowUnfree = true;
              inherit system;
            };
          };
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
