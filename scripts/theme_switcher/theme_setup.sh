#!/bin/bash

source /opt/Radio-VNC/functions.sh

mkdir /usr/share/ThemeSwitcher

wget https://github.com/GingerCam/Radio-VNC/raw/dev/scripts/theme_switcher/config.tar.gz -O /usr/share/ThemeSwitcher/config.tar.gz
wget https://github.com/GingerCam/Radio-VNC/raw/dev/scripts/theme_switcher/Backgrounds.tar.gz -O /home/pi/Backgrounds/Backgrounds.tar.gz
wget https://github.com/GingerCam/Radio-VNC/raw/dev/scripts/theme_switcher/desktops.tar.gz -O /home/pi/.config/autostart/desktops.tar.gz
wget https://github.com/GingerCam/Radio-VNC/raw/dev/scripts/theme_switcher/icons.tar.gz -O /usr/share/icons/icons.tar.gz
wget https://github.com/GingerCam/Radio-VNC/raw/dev/scripts/theme_switcher/themes.tar.gz -O /usr/share/themes/themes.tar.gz

tar -xvzf /usr/share/ThemeSwitcher/config.tar.gz -C /usr/share/ThemeSwitcher/
tar -xvzf /usr/share/themes/themes.tar.gz -C /usr/share/themes/
tar -xvzf /usr/share/icons/icons.tar.gz -C /usr/share/icons/
tar -xvzf /home/pi/.config/autostart/desktops.tar.gz -C /home/pi/.config/autostart/
tar -xvzf /home/pi/Backgrounds/Backgrounds.tar.gz -C /home/pi/Backgrounds