#!/bin/bash

if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
  return
else
  exit
fi

branch=dev
USER=${SUDO_USER:-$(who -m | awk '{ print $1 }')}
config=/home/$USER/.config

curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/setup.sh >> /tmp/setup.sh

if cmp -s /tmp/setup.sh /usr/bin/script.sh; then
  exit
else
  return
fi

curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/other-files/update.desktop -o $config/autostart/update.desktop
