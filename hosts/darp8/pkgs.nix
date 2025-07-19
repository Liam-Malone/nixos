{
  pkgs,
  ...
}:

{
  # BEGIN PACKAGES
  home.packages = with pkgs; [
    audacity
    android-studio
    bat
    brave
    brightnessctl
    btop
    comma
    emacs-all-the-icons-fonts
    emacsPackages.pdf-tools
    exfatprogs
    fastfetch
    filezilla
    floorp
    fzf
    genymotion
    gimp
    gtk4
    gvfs
    grimblast
    htop
    hyprpicker
    imagemagick
    kdePackages.kdenlive
    keepassxc
    libsForQt5.polkit-kde-agent
    localsend
    mpv
    mupdf
    nautilus
    networkmanagerapplet
    networkmanager_dmenu
    nwg-look
    openvpn
    overskride
    pamixer
    pavucontrol
    powertop
    prismlauncher
    protonvpn-cli
    pywal
    qbittorrent
    signal-desktop
    swaynotificationcenter
    swww
    texliveFull
    xfce.thunar
    xfce.thunar-volman
    tree
    waybar
    wev
  ];

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
        fastfetch = "fastfetch -c $HOME/.config/fastfetch/config.json";
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
}

