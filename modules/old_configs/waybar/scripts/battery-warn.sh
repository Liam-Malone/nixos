#!/usr/bin/env bash
notif_id=$1

bat_alert_lvl=15
bat_lvl=$(grep "" /sys/class/power_supply/BAT0/capacity )
bat_status=$(grep Discharging /sys/class/power_supply/BAT0/status )

if (( $bat_lvl < $bat_alert_lvl )) && [ $bat_status == "Discharging" ]; then
    dunstify -u critical "Low Battery" "Connect Power Adapter" -i /usr/share/icons/Adwaita/symbolic/status/battery-caution-symbolic.svg -r $notif_id -t 60000
else 
    hist_check=$(dunstctl history | grep $notif_id)
    if [[ $hist_check == "" ]]; then
        dunstctl close
    fi
    dunstctl history-rm $notif_id 
fi


