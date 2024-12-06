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
    ghostty = {
      inputs = {
        nixpkgs-stable.follows = "nixpkgs";
        nixpkgs-unstable.follows = "nixpkgs";
      };
      url = "git+ssh://git@github.com/ghostty-org/ghostty";
    };
  };

  outputs = { self, nixpkgs, ghostty, hyprland, ... }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            hyprland.nixosModules.default
            ./hosts/default/configuration.nix
            {
              environment.systemPackages = [
                ghostty.packages.x86_64-linux.default
              ];
            }
          ];
        };
	gamemachine = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit inputs;};
          modules = [
            ./hosts/gamemachine/configuration.nix
            ./modules/nvidia.nix
          ];
        };
      };
    };
}
