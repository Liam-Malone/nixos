{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:

let
  home = builtins.getEnv "HOME";
in
{
  programs.waybar = {
      enable = true;
      systemd.enable = true;
      style = ''
        ${builtins.readFile ../style.css}
      '';
  };
}
