{ pkgs, ... }:

{
  home.packages = with pkgs; [ blueman ];
  services = {
    mpris-proxy.enable = true;
    blueman-applet.enable = true;
  };
}
