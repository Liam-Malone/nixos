#!/usr/bin/env python
import os
import sys

discharging = str("discharging")


def alert(id):
    stream = os.popen("cat /sys/class/power_supply/BAT0/capacity")
    output = stream.read()
    battery = int(output.split('\n')[0])

    stream = os.popen("cat /sys/class/power_supply/BAT0/status")
    output = stream.read()
    status = str(output.split('\n')[0]).lower().strip()

    if battery <= 10 and status == discharging:
        os.system(f'dunstify -u critical "Low Battery" "Connect Power Adapter" -i /usr/share/icons/Adwaita/symbolic/status/battery-caution-symbolic.svg -r {id} -t 60000')
    else:
        stream = os.popen(f'dunstctl history | grep {id}')
        output = stream.read()
        if output.strip() != '':
            os.system('dunstctl close')
        os.system(f'dunstctl history-rm {id}')


if __name__ == "__main__":
    alert(int(sys.argv[1]))
