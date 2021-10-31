#!/bin/bash
#/usr/bin/dbus-launch /usr/bin/code --extensions-dir /home/user/.config/Code/extensions --disable-gpu --no-sandbox $@
/usr/bin/dbus-launch /usr/bin/code --no-sandbox --disable-gpu --disable-gpu-sandbox --disable-software-rasterizer --extensions-dir /home/user/.config/Code/extensions $@
