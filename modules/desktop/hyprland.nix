{
  config,
  inputs,
  lib,
  pkgs,
  osConfig,
  ...
}:

{
  home.packages = with pkgs; [
    hyprpicker
    hyprlock
    hypridle
    hyprpaper
    hyprland-protocols
    inputs.hyprsunset
    # inputs.hyprsysteminfo
    # hyprpolkit -- not in nixpkgs yet
  ];

  imports = [
    ./waybar.nix
  ];

  wayland.windowManager.hyprland = {
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    enable = true;
    xwayland.enable = true;
    systemd = {
      enable = true;
      variables = [
        "--all"
      ];
    };
  };

  lib.inputMethod.fcitx5.waylandFrontend = true;

  programs = {
    hyprlock = {
      enable = true;
    };
  };

  services = {
    hyprpaper = {
      enable = true;
    };
    hypridle = {
      enable = true;
    };
  };
}
