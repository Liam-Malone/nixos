{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    systemd.target = "hyprland-session.target";
    style = ''
      ${builtins.readFile ../waybar.css}
    '';
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;
        margin-top = 2;
        margin-bottom = 2;
        margin-left = 2;
        margin-right = 2;

        modules-left = [
          "custom/kernel"
          "keyboard-state"
          "custom/wofi"
          "hyprland/workspaces"
        ];
        modules-center = [
          "hyprland/window"
        ];
        modules-right = [
          "tray"
          "battery"
          "pulseaudio#audio"
          "clock"
        ];

        "custom/kernel" = {
          exec = "uname -r | sed 's/-a.*//p'";
          format = "<big></big>{}";
          interval = "once";
        };

        "keyboard-state" = {
          capslock = true;
          format = "{icon}";
          format-icons = { 
            unlocked = "";
            locked = "";
          };
        };

        "custom/wofi" = {
          format = "<big></big>";
          on-click = "pkill wofi || wofi --show drun";
          tooltip = false;
        };

        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
          on-click = "activate";
          format = "{icon}";
          persistent-workspaces = {
            "*" = 5;
          };
          format-icons = {
            "1" = "I";
            "2" = "II";
            "3" = "III";
            "4" = "IV";
            "5" = "V";
            "6" = "VI";
            "7" = "VII";
            "8" = "VIII";
            "9" = "IX";
            "10" = "X";
          };
        };

        "hyprland/window" = {
            format = "{}";
            rewrite = [
              {
                "(.*) — Mozilla Firefox" =  "🌎 $1";
              }
            ];
            separate-outputs = false;
         };

        "tray" = {
          icon-size = 14;
          spacing = 8;
        };

        "battery" = {
          states = {
            good = 90;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󱘖 {capacity}%";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          on-click = "";
          on-update = "exec ${../scripts/battery-warn.sh} 255";
          tooltip = true;
         };

        "pulseaudio#audio" = {
            format = "<big>{icon}</big> {volume}%";
            format-muted = "<big>󰖁</big> {volume}%";
            format-bluetooth = "󰂯{icon}";
            format-bluetooth-muted = "󰂯󰖁 {volume}%";
            format-icons = {
                headphone = "󰋋";
                hand-free = "󰋋";
                headset = "󰋋";
                phone = "";
                portable = "";
                car = "";
                default = [
                  "󰕿"
                  "󰖀"
                  "󰕾"
                ];
            };
            on-click = "pamixer -t";
            on-click-right = "pavucontrol";
            on-scroll-down = "pamixer -d 5";
            on-scroll-up = "pamixer -i 5";
            tooltip = true;
            tooltip-format = "{icon} {desc} {volume}%";
         };

        "clock" = {
            interval = 1;
            format = "<big></big> {:%d/%m} :: <big>󰥔</big> {:%R}"
         };
      };
    };
  };
}
