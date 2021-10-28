#!/bin/bash
/usr/bin/dbus-launch /usr/bin/code --extensions-dir /home/user/.config/Code/extensions --disable-gpu --no-sandbox --disable-software-rasterizer --disable-gpu-sandbox $@
