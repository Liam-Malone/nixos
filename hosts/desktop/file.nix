{ cfg, config, context, pkgs, ... }:

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
    # Fonts
    ".local/share/fonts" = {
        source = ../../fonts;
        outOfStoreSymlink = true;
        recursive = true;
    };

    # Configs
    ".config/hypr" = {
      source = ../../configs/hypr-desktop;
      outOfStoreSymlink = true;
      recursive = true;
    };
    ".config/DankMaterialShell" = {
      source = ../../configs/dms-desktop;
      outOfStoreSymlink = true;
      recursive = true;
    };
    ".config/river" = {
      source = ../../configs/river;
      outOfStoreSymlink = true;
      recursive = true;
    };
    ".config/emacs" = {
      source = ../../configs/emacs;
      outOfStoreSymlink = true;
      recursive = true;
    };
    ".config/waybar" = {
      source = ../../configs/waybar;
      outOfStoreSymlink = true;
      recursive = true;
    };
    ".config/ghostty" = {
      source = ../../configs/ghostty;
      outOfStoreSymlink = true;
      recursive = true;
    };
    ".config/nvim" = {
      source = ../../configs/nvim;
      outOfStoreSymlink = true;
      recursive = true;
    };
    ".config/wofi" = {
      source = ../../configs/wofi;
      outOfStoreSymlink = true;
      recursive = true;
    };
    ".config/swaync" = {
      source = ../../configs/swaync;
      outOfStoreSymlink = true;
      recursive = true;
    };
    ".config/fastfetch" = {
      source = ../../configs/fastfetch;
      outOfStoreSymlink = true;
      recursive = true;
    };
  };
}
