{ config, pkgs, cfg, ... }:

let
  inherit (config.home) username homeDirectory;

  mkSymlinkAttrs = import ../../utils/mkSymlinkAttrs.nix {
    inherit pkgs;
    inherit (cfg) context runtimeRoot;
    hm = config.lib; # same as: cfg.context.inputs.home-manager.lib.hm;
  };

in
{
  # Symlink dotfiles
  home.file = mkSymlinkAttrs {
    ".config/hypr" = {
      source = ../../modules/non-nix_configs/hypr;
      outOfStoreSymlink = true;
      recursive = true;
    };

    ".config/emacs" = {
      source = ../../modules/non-nix_configs/emacs;
      outOfStoreSymlink = true;
      recursive = true;
    };

    ".config/ghostty" = {
      source = ../../modules/non-nix_configs/ghostty;
      outOfStoreSymlink = true;
      recursive = true;
    };

    ".config/kitty" = {
      source = ../../modules/non-nix_configs/kitty;
      outOfStoreSymlink = true;
      recursive = true;
    };

    ".config/nvim" = {
      source = ../../modules/non-nix_configs/nvim;
      outOfStoreSymlink = true;
      recursive = true;
    };

    ".config/wofi" = {
      source = ../../modules/non-nix_configs/wofi;
      outOfStoreSymlink = true;
      recursive = true;
    };
  };
}
