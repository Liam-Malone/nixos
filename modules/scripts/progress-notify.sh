#!/usr/bin/env bash

notify='dunstify'

muteToggleNotify() {
        volume=$(pamixer --get-volume)
        muted=$(pamixer --get-mute)

        icon=""

        if [ $muted == "true" ]; then
            str="Muted"
            icon="audio-volume-muted"
        else
            if [ $volume -eq 0 ]; then
                icon="audio-volume-low"
            elif [ $volume -le 30 ]; then
                icon="audio-volume-medium"
            elif [ $volume -le 70 ]; then
                icon="audio-volume-high"
            else
                icon="audio-volume-muted"
            fi
            str="Unmuted"
        fi

        $notify -a volume_indicator -h string:x-canonical-private-synchronous:audio "$str" -h int:value:"$volume" -t 1500 --icon $icon
}

notifyMuted() {
        volume=$(pamixer --get-volume)
        muted=$(pamixer --get-mute)
        $notify -a volume_indicator -h string:x-canonical-private-synchronous:audio "Muted" -h int:value:"$volume" -t 1500 --icon audio-volume-muted
}

notifyAudio() {
        volume=$(pamixer --get-volume)
        muted=$(pamixer --get-mute)

        $muted && notifyMuted "$volume" && return

        if [ $volume -eq 0 ]; then
                notifyMuted "$volume"
        elif [ $volume -le 30 ]; then
                $notify --appname=volume_indicator -h string:x-canonical-private-synchronous:audio "Volume: " -h int:value:"$volume" -t 1500 --icon audio-volume-low
        elif [ $volume -le 70 ]; then
                $notify --appname=volume_indicator -h string:x-canonical-private-synchronous:audio "Volume: " -h int:value:"$volume" -t 1500 --icon audio-volume-medium
        else
                $notify --appname=volume_indicator -h string:x-canonical-private-synchronous:audio "Volume: " -h int:value:"$volume" -t 1500 --icon audio-volume-high
        fi
}

notifyBrightness() {
    base_brightness=$(brightnessctl g)
    brightness=$(( $(( $base_brightness * 5 )) + 5 ))
        if [ $brightness -eq 0 ]; then
                $notify --appname=brightness_indicator -h string:x-canonical-private-synchronous:brightness "Brightness: " -h int:value:"$brightness" -t 1500 --icon display-brightness-symbolic
        elif [ $brightness -le 30 ]; then
                $notify --appname=brightness_indicator -h string:x-canonical-private-synchronous:brightness "Brightness: " -h int:value:"$brightness" -t 1500 --icon display-brightness-symbolic
        elif [ $brightness -le 70 ]; then
                $notify --appname=brightness_indicator -h string:x-canonical-private-synchronous:brightness "Brightness: " -h int:value:"$brightness" -t 1500 --icon display-brightness-symbolic
        else
                $notify --appname=brightness_indicator -h string:x-canonical-private-synchronous:brightness "Brightness: " -h int:value:"$brightness" -t 1500 --icon display-brightness-symbolic
        fi
}


case "$1" in
        mute)
                muteToggleNotify
                ;;
        audio)
                notifyAudio
                ;;
        brightness)
                notifyBrightness
                ;;

        *)
                echo "Invalid Arguments:"
                echo "$1"
                exit 2
esac
