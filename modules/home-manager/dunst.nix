{ config, pkgs, lib, ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        offset = "4x4";
        frame_color = "#881798";
        gap_size = 2;
        corner_radius = 10;
        frame_width = 2;
        font = "FiraCodeNerdFont";
        enable_recursive_icon_lookup = true;
        icon_theme = "Arc";
      };

      urgency_low = {
        background = "#050D0E";
        foreground = "#ecefee";
        timeout = 5;
      };
      urgency_normal = {
        background = "#050D0E";
        foreground = "#ecefee";
        timeout = 5;
      };
      urgency_high = {
        background = "#cc474f";
        foreground = "#eceffe";
        timeout = 5;
      };

      volume_rule = {
        appname = "volume_indicator";
        background = "#050D0E88";
        foreground = "#ecefee";
        timeout = 1;
      };
      brightness_rule = {
        appname = "brightness_indicator";
        background = "#050D0E88";
        foreground = "#ecefee";
        timeout = 1;
      };
    };
  };
}
