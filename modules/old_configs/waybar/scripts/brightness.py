#!/usr/bin/env python

import os

stream = os.popen("brightnessctl -m")
output = stream.read()

perc = output.split(',')[3]

print(perc)
