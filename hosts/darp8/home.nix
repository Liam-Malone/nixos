{ cfg, config, pkgs, lib, callPackage, inputs, ... }:

{
  home.username = cfg.username;
  home.homeDirectory = cfg.homeDirectory;

  imports = [
    # home.file imports
    ./file.nix

    # general modules
    ../../modules/home-manager/dunst.nix
    ../../modules/home-manager/tmux.nix
    ../../modules/home-manager/fastfetch.nix

    # desktop
    ../../modules/desktop/bluetooth.nix
    ../../modules/desktop/waybar.nix
  ];

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  home.packages = with pkgs; [
    audacity
    android-studio
    bat
    brave
    brightnessctl
    btop
    emacs-all-the-icons-fonts
    emacsPackages.pdf-tools
    exfatprogs
    filezilla
    floorp
    genymotion
    gimp
    gnome-keyring
    gtk4
    gvfs
    grim
    grimblast
    htop
    imagemagick
    kdePackages.kdenlive
    keepassxc
    libsForQt5.polkit-kde-agent
    localsend
    mpv
    mupdf
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
    texliveFull
    tree
    unzip
    wev
    wl-clipboard
    xdg-user-dirs
    zip
  ];

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


  xdg.enable = true;
  xdg.configFile = {
    "emacs" = {
      source = ../../modules/non-nix_configs/emacs;
      recursive = true;
    };
    "user-dirs.dirs".source = ../../modules/non-nix_configs/user-dirs.dirs;
    "user-dirs.locale".source = ../../modules/non-nix_configs/user-dirs.locale;
  };

  # BEGIN PROGRAMS
  programs = {
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
        nixrebuild = "nixos-rebuild build --flake ~/personal/nixos#darp8 && sudo nixos-rebuild switch --flake ~/personal/nixos#darp8";
        nixbuild = "sudo nixos-rebuild switch --flake";
        nixtest = "sudo nixos-rebuild test --flake";
        new = "source $HOME/.bashrc";
        newbar = "pkill waybar; waybar &disown";
        ping = "ping -c 5";
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
    wofi.enable = true;
  };


  # BEGIN SERVICES
  services = {
    hyprpaper.enable = true;
    hypridle.enable = true;

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
