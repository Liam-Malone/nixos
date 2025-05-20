{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprsunset = {
        url = "github:hyprwm/hyprsunset";
        inputs.nixpkgs.follows = "hyprland";
    };
    hyprsysteminfo = {
        url = "github:hyprwm/hyprsysteminfo";
        inputs.nixpkgs.follows = "hyprland";
    };
  };

  outputs = { self, nixpkgs, hyprland, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
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
          specialArgs = {inherit inputs; cfg = defaultCfg; };
          modules = [
            hyprland.nixosModules.default
            ./hosts/darp8/configuration.nix
            {
              environment.systemPackages = [
              ];
            }
          ];
        };
        desktop = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            hyprland.nixosModules.default
            ./hosts/desktop/configuration.nix
            {
              environment.systemPackages = [
              ];
            }
          ];
        };
      };
    };
}
