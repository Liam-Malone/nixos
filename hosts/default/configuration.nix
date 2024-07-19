# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;

  networking = {
    networkmanager = {
      enable = true;  # Easiest to use and most distros use this by default.
      wifi.backend = "iwd";
    };
    hostName = "nixos-laptop";
    firewall.enable = false;
    wireless.iwd = {
      enable = true;
      settings = {
        IPv6.Enabled = true;
        Settings.Autoconnect = true;
      };
    };
    # Configure network proxy if necessary
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n= {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      #enabled = "fcitx5";
      type = "fcitx5";
      enable = true;
      fcitx5 = {
        # waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-mozc
          fcitx5-gtk
          fcitx5-chinese-addons
        ];
      };
    };
  };

  # Enable the X11 windowing system.
  services = {
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
      windowManager = {
        i3.enable = true;
        dwm.enable = true;
      };
    };
    # displayManager.sddm = {
    #   enable = true;
    #   wayland.enable = true;
    # };
    desktopManager.plasma6.enable = true;
    libinput.enable = true;
    greetd = {
      enable = true;
      restart = true;
      settings = {
        default_session = {
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --cmd Hyprland";
        };
      };
    };
    blueman.enable = true;
    printing.enable = true; # Enable CUPS to print documents.
    gvfs.enable = true;
    auto-cpufreq.enable = true;
    thermald.enable = true;
  };

  # powerManagement = {
  #   enable = true;
  #   powertop.enable = true;
  # };
  services.power-profiles-daemon.enable = false;

  environment.etc."greetd/environments".text = ''
      Hyprland
      none+i3
      non+dwm
      '';

  hardware = {
    bluetooth.enable = true;
    graphics.enable = true;
    pulseaudio.enable = true;

    # System76 Devices
    system76.enableAll = true;
  };

  # security.pam.services.swaylock = {};
  security.pam.services.hyprlock = {};

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    liberation_ttf
    fira-code
    fira-code-symbols
    mplus-outline-fonts.githubRelease
    dina-font
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  nixpkgs.config.allowUnfree = true;
  nixpkgs.overlays = [
    (final: prev: {
      dwm = prev.dwm.overrideAttrs (old: {src = /home/liamm/oss/dwm;});
    })
    (final: prev: {
      dmenu = prev.dmenu.overrideAttrs (old: {src = /home/liamm/oss/dmenu;});
    })
    (final: prev: {
      slstatus = prev.slstatus.overrideAttrs (old: {src = /home/liamm/oss/slstatus;});
    })
  ];
  # nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
  #   "steam"
  #   "steam-original"
  #   "steam-run"
  # ];


  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
    trusted-users = [ "root" "@wheel" ];
  };

  nix.gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 20d";
  };
  nix.optimise = {
    automatic = true;
    dates = [ "00:00" ];
  };

  users.users.liamm = {
    isNormalUser = true;
    description = "liamm";
    extraGroups = [ "networkmanager" "wheel" "disk" "power" "video" "davfs2" "input" ]; # Enable ‘sudo’ for the user.
  };

  programs = {
    dconf.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    nix-ld.enable = true;
    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    mtr.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  home-manager = {
    useGlobalPkgs = true;
    extraSpecialArgs = { inherit inputs; };
    users = {
      "liamm" = import ./home.nix;
    };
  };
 
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    fd
    file
    ripgrep
    wget
    spotify
    discord
    wl-clipboard
    alacritty
    libnotify
    mesa
    libdrm
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
      # gtkUsePortal = true;
      extraPortals = with pkgs;[ 
        xdg-desktop-portal-gtk 
        xdg-desktop-portal-wlr
        xdg-desktop-portal-hyprland
      ];
      config = {
        common = {
            default = [ "gtk" ];
        };
      };
    };
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "23.11"; # Did you read the comment?
}
