{ config, pkgs, lib, ... }:

{
  home.username = "liamm";
  home.homeDirectory = "/home/liamm";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.

  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    brave
    brightnessctl
    contour
    emacs-all-the-icons-fonts
    emacsPackages.pdf-tools
    exfatprogs
    firefox
    floorp
    gnome.gnome-keyring
    gnome.nautilus
    grimblast
    htop
    keepassxc
    libtool
    libreoffice
    minecraft
    neofetch
    networkmanagerapplet
    openvpn
    pamixer
    pavucontrol
    picom
    powertop
    praat
    signal-desktop
    swayidle
    swww
    texliveFull
    thunderbird
    tree
    wev
    # etcher ## Currently Uses Electron-19 -- which is marked EOL
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
    EDITOR = "emacs";
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
  qt.enable = true;
  qt.platformTheme = "gtk";
  qt.style.name = "adwaita-dark";

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
    "alacritty" = {
      recursive = true;
      source = ../../modules/old_configs/alacritty;
    };
    "contour" = {
      recursive = true;
      source = ../../modules/old_configs/contour;
    };
    "emacs" = {
      recursive = true;
      source = ../../modules/old_configs/emacs;
    };
    "ghostty" = {
      recursive = true;
      source = ../../modules/old_configs/ghostty;
    };
    "hypr" = {
      recursive = true;
      source = ../../modules/old_configs/hypr;
    };
    "kitty" = {
      recursive = true;
      source = ../../modules/old_configs/kitty;
    };
    "nvim" = {
      recursive = true;
      source = ../../modules/old_configs/nvim;
    };
    "river" = {
      recursive = true;
      source = ../../modules/old_configs/river;
    };
    "swaylock" = {
      recursive = true;
      source = ../../modules/old_configs/swaylock;
    };
    "waybar" = {
      recursive = true;
      source = ../../modules/old_configs/waybar;
    };
    "wofi" = {
      recursive = true;
      source = ../../modules/old_configs/wofi;
    };
    "user-dirs.dirs".source = ../../modules/old_configs/user-dirs.dirs;
    "user-dirs.locale".source = ../../modules/old_configs/user-dirs.locale;
  };
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    xwayland.enable = true;
    # extraConfig = ''
    #   ${builtins.readFile ./hyprland.conf}
    #   '';
  };

  # BEGIN PROGRAMS

  programs.bash = {
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
    '';
    shellAliases = {
      ls = "ls --color=auto";
      ll = "ls -l";
      la = "ls -lA";
      ping = "ping -c 5";
      kpx = "keepassxc-cli open";
      nixbuild = "sudo nixos-rebuild switch --flake";
      nixtest = "sudo nixos-rebuild test --flake";
      vi = "\vim";
      emacsd = "emacs --daemon";
      emacsc = "emacsclient -c -a 'emacs'";
      new = "source $HOME/.bashrc";
      newbar = "pkill waybar; waybar &disown";
      ".." = "cd ..";
      set-github-var = "export GITHUB=$(sed -n 2p ~/documents/.git_keys)";
      set-gitlab-var = "export GITLAB=$(sed -n 4p ~/documents/.git_keys)";
    };
  };
  programs.emacs = {
    enable = true;
    # extraPackages = epkgs: [
    #   epkgs.nix-mode
    #   epkgs.magit
    # ];
  };
  programs.feh.enable = true;
  programs.git = {
    enable = true;
    diff-so-fancy.enable = true;
    userEmail = "maloneliam@proton.me";
    userName = "Liam Malone";
  };
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;
    vimAlias = true;
    vimdiffAlias = true;
  };
  programs.swaylock.enable = true;
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "hyprland-session.target";
  };
  programs.wofi.enable = true;


  # BEGIN SERVICES

  services.blueman-applet.enable = true;
  services.dunst = {
    enable = true;
    # waylandDisplay = true;
  };

  services.emacs = {
    enable = true;
    client = {
      enable = true;
      arguments = [
        "-c"
	      "-a emacs"
      ];
    };
    startWithUserSession = true;
  };

  # services.flameshot = {
  #   enable = true;
  #   settings = {
  #     General = {
  #       disabledTrayIcon = true;
  #       showStartupLaunchMessage = false;
  #     };
  #   };
  # };

  services.gnome-keyring.enable = true;
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };
  #services.nexcloud-client.enable = true;
  services.swayidle.enable = true;
}
