#!/bin/bash
#/usr/bin/dbus-launch /usr/bin/code --no-sandbox --disable-gpu --disable-gpu-sandbox --wait --extensions-dir /home/user/.config/Code/extensions $@
/usr/bin/code --no-sandbox --disable-gpu --disable-dev-shm-usage --wait --extensions-dir /home/user/.config/Code/extensions $@
