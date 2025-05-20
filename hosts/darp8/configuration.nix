{ cfg, config, lib, pkgs, inputs, ... }:

{
  imports = [
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  boot = {
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    plymouth.enable = true;
  };

  networking = {
    hostName = "darp8";

    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };

    firewall = {
      enable = true;

      # Open ports in the firewall.
      allowedTCPPorts = [ 21 22 80 443 4070 ];
      allowedUDPPorts = [ 4070 ];

      allowedTCPPortRanges = [
        { from = 8000; to = 8010; }
      ];

      allowPing = true;
    };

    wireless.iwd = {
      enable = true;
      settings = {
        IPv6.Enabled = true;
        Settings.Autoconnect = true;
      };
    };
  };

  time.timeZone = "Europe/Madrid";

  i18n= {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-gtk
          fcitx5-chinese-addons
        ];
      };
    };
  };

  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        userServices = true;
      };
    };

    greetd = {
      enable = true;
      restart = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd Hyprland";
        };
      };
    };

    libinput.enable = true;
    blueman.enable = true;
    gvfs.enable = true;
    auto-cpufreq.enable = true;
    thermald.enable = true;
    power-profiles-daemon.enable = false;
    pulseaudio.enable = false;
  };

  security.pam.services.hyprlock = {};
  environment.etc."greetd/environments".text = ''
    Hyprland
  '';

  hardware = {
    bluetooth.enable = true;
    graphics = {
      enable = true;
      extraPackages = with pkgs;[
        intel-compute-runtime
        intel-media-driver
      ];
    };
    system76.enableAll = true;
  };

  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-emoji
      liberation_ttf
      fira-code-symbols
      mplus-outline-fonts.githubRelease
      dina-font
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
    ];

    fontconfig = {
      enable = true;
      includeUserConf = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    trusted-users = [ "root" "@wheel" ];
    allowed-users = [ "root" "@wheel" ];
  };

  nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 10d";
  };
  nix.optimise = {
    automatic = true;
    dates = [ "00:00" ];
  };

  users.users.liamm = {
    isNormalUser = true;
    description = "liamm";
    extraGroups = [ "networkmanager" "wheel" "disk" "power" "video" "davfs2" "input" ];
  };

  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };
    hyprland = {
      enable = true;
      package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      xwayland.enable = true;
    };
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    hyprlock.enable = true;
    dconf.enable = true;
    nix-ld.enable = true;
    mtr.enable = true;
  };

  lib.inputMethod.fcitx5.waylandFrontend = true;

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs; inherit cfg; };
    users = {
      "${cfg.username}" = import ./home.nix;
    };
    backupFileExtension = ".bak";
  };
 
  environment.systemPackages = with pkgs; [
    bat
    discord
    ghostty
    glib
    gnome-keyring
    fd
    file
    libnotify
    libdrm
    mesa
    neovim
    ripgrep
    spotify
    unzip
    uxplay
    vim
    wget
    wl-clipboard
    xdg-user-dirs
    zip
  ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
  };

  xdg = {
    mime.enable = true;
    portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = with pkgs;[ 
        xdg-desktop-portal-gtk 
        xdg-desktop-portal-wlr
      ];
      config = {
        common = {
          default = [ "gtk" ];
        };
      };
    };
  };

  # This option defines the first version of NixOS you have installed on this particular machine
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
