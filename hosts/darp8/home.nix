{
  cfg,
  hyprplugins,
  config,
  pkgs,
  lib,
  callPackage,
  inputs,
  ...
}:

{
  home.username = cfg.username;
  home.homeDirectory = cfg.homeDirectory;

  imports = [
    ./file.nix # config file out-of-store links
    ./pkgs.nix # system pkgs
    ./services.nix # system services

    # general modules
    ../../modules/home-manager/tmux.nix
  ];

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.sessionVariables = {
    EDITOR = "emacsclient";
    GIT_EDITOR = "nvim";
    NIX_SHELL_PRESERVE_PROMPT = 1;
    NIX_CONFIG_DIR = "${cfg.homeDirectory}/personal/nixos";
    HYPR_EXPO_LIB = "${hyprplugins.hyprexpo_dir}/lib/libhyprexpo.so";
  };

  nix.settings.extra-trusted-substituters = [
    "https://ghostty.cachix.org"
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # THEMING

  ## QT SECTION
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style.name = "adwaita-dark";
  };

  ## GTK SECTION
  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };
    theme = {
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };
    iconTheme = {
      package = pkgs.arc-icon-theme;
      name = "arc-icon-theme";
    };
  };


  # ENV SETTINGS
  xdg.enable = true;
  xdg.configFile = {
    "emacs" = {
      source = ../../configs/emacs;
      recursive = true;
    };

    "user-dirs.dirs".source = ../../configs/user-dirs.dirs;
    "user-dirs.locale".source = ../../configs/user-dirs.locale;
  };


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
