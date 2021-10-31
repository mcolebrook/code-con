#!/bin/bash
/usr/bin/dbus-launch /usr/bin/code --no-sandbox --disable-gpu --disable-gpu-sandbox --disable-software-rasterizer --wait --extensions-dir /home/user/.config/Code/extensions $@
