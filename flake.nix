{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hyprland.url = "github:hyprwm/Hyprland";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dankMaterialShell = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "github:quickshell-mirror/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
  };

  outputs = { self, nixpkgs, hyprland, ... }@inputs:
    let
      system = "x86_64-linux";
      # pkgs = nixpkgs.legacyPackages.${system};
      pkgs = import nixpkgs.legacyPackages {
          inherit system;
          overlays = [
            # Hyprland & Plugins Overlays
            (final: prev: {
               hyprlandPlugins = prev.hyprlandPlugins // {
                 hyprexpo = inputs.hyprland-plugins.packages.${prev.system}.hyprexpo;
                 hyprbars = inputs.hyprland-plugins.packages.${prev.system}.hyprbars;
               };
            })
            (final: prev: {
              hyprland = inputs.hyprland.packages.${prev.system}.hyprland;
            })
            (final: prev: {
              xdg-desktop-portal-hyprland = inputs.hyprland.packages.${prev.system}.xdg-desktop-portal-hyprland;
            })

            # Quickshell Overlays
            (final: prev: {
              quickshell = inputs.quickshell.packages.${prev.system}.quickshell;
            })
          ];
      };
      defaultCfg = rec {
        username = "liamm";
        homeDirectory = "/home/${username}";
        runtimeRoot = "${homeDirectory}/personal/nixos";
        context = self;
      };
    in
    {
      nixosConfigurations = {
        darp8 = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; cfg = defaultCfg; };
          modules = [
            hyprland.nixosModules.default
            ./hosts/darp8/configuration.nix
          ];
        };
        desktop = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; cfg = defaultCfg; };
          modules = [
            hyprland.nixosModules.default
            ./hosts/desktop/configuration.nix
          ];
        };
      };
    };
}
