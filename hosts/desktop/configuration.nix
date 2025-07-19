{ config, lib, pkgs, inputs, ... }:

{
  imports = [
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;

  networking = {
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    hostName = "nixos-desktop";
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

  time.timeZone = "Europe/Dublin";

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
    
    xserver.videoDrivers = [ "nvidia" ];
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
      ];
    };
    nvidia = {
    	modesetting.enable = true;
    	powerManagement.enable = true;
    	open = true;
    	nvidiaSettings = true;
    };
  };

  fonts.packages = with pkgs; [
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
    dconf.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    nix-ld.enable = true;
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
 
  environment.systemPackages = with pkgs; [
    vim
    fd
    file
    ripgrep
    wget
    glib
    spotify
    discord
    discord-canary
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

  # services.openssh.enable = true;

  # This option defines the first version of NixOS you have installed on this particular machine
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.11"; # Did you read the comment?
}
