{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # nix-index stuff
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    wpilib.url = "github:frc4451/frc-nix";
    thorium.url = "github:dreamgineer/nix-thorium";
    nix-alien.url = "github:thiagokokada/nix-alien";

    home-manager = {
      url = "github:nix-community/home-manager";
      # The `follows` keyword in inputs is used for inheritance.
      # Here, `inputs.nixpkgs` of home-manager is kept consistent with
      # the `inputs.nixpkgs` of the current flake,
      # to avoid problems caused by different versions of nixpkgs.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    winapps = {
      url = "github:winapps-org/winapps";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    lix = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";
    
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs =
    {
      self,
      lix,
      nixpkgs,
      nix-index-database,
      wpilib,
      thorium,
      home-manager,
      winapps,
      lanzaboote,
      nix-flatpak,
      stylix,
      ...
    }:
    {
      # replace 'nyx' with your hostname here.
      nixosConfigurations = nixpkgs.lib.genAttrs [ "nyx" "nixos" ] (
        hostname:
        nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          specialArgs = { inherit self system winapps; };
          modules = [
            stylix.nixosModules.stylix
            ./configuration.nix
            ./modules

            # comma & nix-index
            nix-index-database.nixosModules.nix-index
            { programs.nix-index-database.comma.enable = true; }

            # Add WPILib packages
            (
              { ... }:
              {
                environment.systemPackages = [
                  wpilib.packages.${system}.glass
                  wpilib.packages.${system}.advantagescope
                  wpilib.packages.${system}.vscode-wpilib
                  wpilib.packages.${system}.sysid
                  thorium.packages.${system}.default
                ];
              }
            )

            # nix-alien
            (
              { self, pkgs, ... }:
              {
                nixpkgs.overlays = [
                  self.inputs.nix-alien.overlays.default
                ];
                environment.systemPackages = with pkgs; [
                  nix-alien
                ];
                # Optional, needed for `nix-alien-ld`
                programs.nix-ld.enable = true;
              }
            )

            # GoDNS systemd service
            ./programs/godns/service.nix

            # Steam
            ./programs/steam

            home-manager.nixosModules.home-manager
            {
              home-manager.users.dgnr = import ./modules/home;
              home-manager.backupFileExtension = "bak";

              # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
            }

            # Lanzaboote
            lanzaboote.nixosModules.lanzaboote

            # Lix
            lix.nixosModules.default

            # Flatpak
            nix-flatpak.nixosModules.nix-flatpak
          ];
        }
      );
      checks = nixpkgs.lib.genAttrs [ "x86_64-linux" ] (
        system:
        let
          inherit (nixpkgs) lib;
          nixosMachines = lib.mapAttrs' (
            name: config: lib.nameValuePair "nixos-${name}" config.config.system.build.toplevel
          ) ((lib.filterAttrs (_: config: config.pkgs.system == system)) self.nixosConfigurations);
        in
        nixosMachines
      );
    };
}
