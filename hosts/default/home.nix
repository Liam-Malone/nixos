{ config, pkgs, lib, callPackage, inputs, ... }:

{
  home.username = "liamm";
  home.homeDirectory = "/home/liamm";

  imports = [
    # home-manager
    inputs.ags.homeManagerModules.default
    ../../modules/home-manager/dunst.nix
    ../../modules/home-manager/tmux.nix
    ../../modules/home-manager/fastfetch.nix
    ../../modules/home-manager/terminals/alacritty.nix

    # desktop
    ../../modules/desktop/bluetooth.nix
    ../../modules/desktop/hyprland.nix
  ];
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    android-studio
    audacity
    brave
    brightnessctl
    emacs-all-the-icons-fonts
    emacsPackages.pdf-tools
    exfatprogs
    filezilla
    firefox
    floorp
    genymotion
    gimp
    gnome-keyring
    gnome-sound-recorder
    gnome-disk-utility
    gparted
    gtk4
    gvfs
    grim
    grimblast
    htop
    imagemagick
    imhex
    kdenlive
    keepassxc
    libsForQt5.polkit-kde-agent
    libtool
    libreoffice
    mpv
    nautilus
    networkmanagerapplet
    nwg-look
    openvpn
    pamixer
    pavucontrol
    powertop
    praat
    prismlauncher
    protonvpn-cli
    protonvpn-gui
    qbittorrent
    signal-desktop
    slstatus
    swww
    teams-for-linux
    texliveFull
    thunderbird
    tree
    unzip
    wev
    wl-clipboard
    xdg-user-dirs
    zip
    zoom-us
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.

  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;
  };

  home.sessionVariables = {
    EDITOR = "emacsclient";
    GIT_EDITOR = "nvim";
    NIX_SHELL_PRESERVE_PROMPT = 1;
  };

  nix.settings.extra-trusted-substituters = [
    "https://ghostty.cachix.org"
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

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

  fonts.fontconfig = {
    enable = true;
  };

  xdg.enable = true;
  xdg.configFile = {
    "contour" = {
      recursive = true;
      source = ../../modules/non-nix_configs/contour;
    };
    "emacs" = {
      recursive = true;
      source = ../../modules/non-nix_configs/emacs;
    };
    "ghostty" = {
      recursive = true;
      source = ../../modules/non-nix_configs/ghostty;
    };
    "kitty" = {
      recursive = true;
      source = ../../modules/non-nix_configs/kitty;
    };
    "nvim" = {
      recursive = true;
      source = ../../modules/non-nix_configs/nvim;
    };
    "river" = {
      recursive = true;
      source = ../../modules/non-nix_configs/river;
    };
    "waybar" = {
      recursive = true;
      source = ../../modules/non-nix_configs/waybar;
    };
    "wofi" = {
      recursive = true;
      source = ../../modules/non-nix_configs/wofi;
    };
    "user-dirs.dirs".source = ../../modules/non-nix_configs/user-dirs.dirs;
    "user-dirs.locale".source = ../../modules/non-nix_configs/user-dirs.locale;
  };
  # BEGIN PROGRAMS

  programs = {
    ags = {
      enable = true;
      configDir = ../../modules/home-manager/ags;
    };
    bash = {
      enable = true;
      enableCompletion = true;
      enableVteIntegration = true;
      initExtra =''
        if [[ -z $ORIG_SHLVL ]]; then
            export ORIG_SHLVL=$SHLVL
        fi;
        if [[ $SHLVL -gt $ORIG_SHLVL ]]; then
            export PS1='\[\e[1;m\e[1;33m\e[1;m\] ($(($SHLVL - $ORIG_SHLVL))) \W\[\e[m\e[m\] 🐧 \[\e[1;32m\]~> \[\e[m\e[m\]'
        else
            export PS1='\[\e[1;m\e[1;33m\e[1;m\] \W\[\e[m\e[m\] 🐧 \[\e[1;32m\]~> \[\e[m\e[m\]'
        fi;
        set -o vi
        fastfetch
      '';
      shellAliases = {
        build = "./build.sh";
        emacsd = "emacs --daemon";
        emacsc = "emacsclient -c -a 'emacs'";
        gap = "git add -p";
        gcp = "git commit -p";
        kpx = "keepassxc-cli open";
        ls = "ls --color=auto";
        ll = "ls -l";
        la = "ls -lA";
        nixbuild = "sudo nixos-rebuild switch --flake";
        nixtest = "sudo nixos-rebuild test --flake";
        new = "source $HOME/.bashrc";
        newbar = "pkill waybar; waybar &disown";
        ping = "ping -c 5";
        set-github-var = "export GITHUB=$(sed -n 2p ~/documents/.git_keys)";
        set-gitlab-var = "export GITLAB=$(sed -n 4p ~/documents/.git_keys)";
        vi = "\\vim";
        work = "nix develop --impure";
        ".." = "cd ..";
      };
    };
    emacs = {
      enable = true;
      package = pkgs.emacs-gtk;
      extraPackages = epkgs: [
        epkgs.pdf-tools 
        epkgs.org-pdftools
      ];
    };
    feh.enable = true;
    git = {
      enable = true;
      lfs.enable = true;
      diff-so-fancy.enable = true;
      userEmail = "maloneliam@proton.me";
      userName = "Liam Malone";
    };
    neovim = {
      enable = true;
      package = pkgs.neovim-unwrapped;
      vimAlias = true;
      vimdiffAlias = true;
    };
    obs-studio = {
      enable = true;
    };
    # swaylock.enable = true;
    waybar = {
      enable = true;
      systemd.enable = true;
      systemd.target = "hyprland-session.target";
    };
    wofi.enable = true;
  };


  # BEGIN SERVICES
  services = {
    blueman-applet.enable = true;
    network-manager-applet.enable = true;

    emacs = {
      enable = true;
      package = pkgs.emacs-gtk;
      client = {
        enable = true;
        arguments = [
          "-c"
	        "-a emacs"
        ];
      };
      startWithUserSession = "graphical";
    };

    gnome-keyring.enable = true;

    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };

    nextcloud-client.enable = true;
  };
}
