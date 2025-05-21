{ pkgs, ... }:

{
  services = {
    emacs = {
      enable = true;
      package = pkgs.emacs-gtk;
      client = {
        enable = true;
        arguments = [
          "-c"
	      "-a emacs"
        ];
      };
      startWithUserSession = "graphical";
    };

    gpg-agent = {
      enable = true;
      defaultCacheTtl = 1800;
      enableSshSupport = true;
    };

    gnome-keyring.enable = true;
    mpris-proxy.enable = true;
    network-manager-applet.enable = true;
    nextcloud-client.enable = true;
    swaync.enable = true;
    swww.enable = true;
  };
}
