{ config, pkgs, ... }:

{
  home.username = "liamm";
  home.homeDirectory = "/home/liamm";

  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    pkgs.htop
    pkgs.firefox
    pkgs.thunderbird
    pkgs.neofetch
    pkgs.tree
    pkgs.cmake
    pkgs.gcc
    pkgs.libtool
    (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
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

  # ENV/APPEARANCE SETTINGS

  fonts.fontconfig = {
    enable = true;
  };

  # BEGIN PROGRAMS

  programs.bash = {
    enable = true;
    enableCompletion = true;
    enableVteIntegration = true;
    initExtra =''
      export PS1='\[\e[1;m\e[1;33m\e[1;m\] \W\[\e[m\e[m\] 🐧 \[\e[1;32m\]~> \[\e[m\e[m\]'
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


  # BEGIN SERVICES

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

  services.flameshot = {
    enable = true;
    settings = {
      General = {
        disabledTrayIcon = true;
        showStartupLaunchMessage = false;
      };
    };
  };

  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
    enableSshSupport = true;
  };

  #services.nexcloud-client.enable = true;
}