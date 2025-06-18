#!/usr/bin/env bash
notif_id=$1

bat_alert_lvl=15
bat_lvl=$(grep "" /sys/class/power_supply/BAT0/capacity )
bat_status=$(grep Discharging /sys/class/power_supply/BAT0/status )

if (( $bat_lvl < $bat_alert_lvl )) && [ $bat_status == "Discharging" ]; then
    notify-send -a low_battery -u critical "Low Battery" "Connect Power Adapter" -i battery-low -r $notif_id -t 1000
fi
