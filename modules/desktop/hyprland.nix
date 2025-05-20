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
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;

    xwayland.enable = true;
    systemd.enable = true;

    # Tell home-manager not to manage the config file
    extraConfig = "";
  };

  lib.inputMethod.fcitx5.waylandFrontend = true;

  programs = {
    hyprlock.enable = true;
  };

  services = {
    hyprpaper.enable = true;
    hypridle.enable = true;
  };
}
