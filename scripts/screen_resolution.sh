#!/bin/bash

source /opt/Radio-VNC/functions.sh
user=pi
width=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f1)
height=$(xrandr --current | grep '*' | uniq | awk '{print $1}' | cut -d 'x' -f2)

if [ $width > "767" ] && [ $height > "1279" ]; then
  sed -i "s/wallpaper=*/wallpaper=/home/$user/.config/big_image.png" /home/$user/.config/pcmanfm/LXDE-pi/desktop-items-0.conf
fi

if [$width < "768"  ] || [ $height < "1280" ]; then
  sed -i "s/wallpaper=*/wallpaper=/home/$user/.config/small_image.png" /home/$user/.config/pcmanfm/LXDE-pi/desktop-items-0.conf
fi

if [$width == "640"  ] || [ $height == "480" ]; then
  sed -i "s/wallpaper=*/wallpaper=/home/$user/.config/very_small_image.png" /home/$user/.config/pcmanfm/LXDE-pi/desktop-items-0.conf
fi
