#!/bin/bash

source /opt/Radio-VNC/functions.sh

mkdir /usr/share/ThemeSwitcher

wget https://github.com/GingerCam/Radio-VNC/raw/$branch/scripts/theme_switcher/archives/config.tar.gz -O /usr/share/ThemeSwitcher/config.tar.gz
wget https://github.com/GingerCam/Radio-VNC/raw/$branch/scripts/theme_switcher/archives/Backgrounds.tar.gz -O /home/pi/Backgrounds/Backgrounds.tar.gz
wget https://github.com/GingerCam/Radio-VNC/raw/$branch/scripts/theme_switcher/archives/desktops.tar.gz -O /home/pi/.config/autostart/desktops.tar.gz
wget https://github.com/GingerCam/Radio-VNC/raw/$branch/scripts/theme_switcher/archives/icons.tar.gz -O /usr/share/icons/icons.tar.gz
wget https://github.com/GingerCam/Radio-VNC/raw/$branch/scripts/theme_switcher/archives/themes.tar.gz -O /usr/share/themes/themes.tar.gz
wget https://github.com/GingerCam/Radio-VNC/raw/$branch/scripts/theme_switcher/scripts/panel_restart -O /home/pi/.panel_restart
wget https://github.com/GingerCam/Radio-VNC/raw/$branch/scrips/theme_switcher/archives/fonts.tar.gz -O /usr/share/fonts

tar -xvzf /usr/share/ThemeSwitcher/config.tar.gz -C /usr/share/ThemeSwitcher/
tar -xvzf /usr/share/themes/themes.tar.gz -C /usr/share/themes/
tar -xvzf /usr/share/icons/icons.tar.gz -C /usr/share/icons/
tar -xvzf /home/pi/.config/autostart/desktops.tar.gz -C /home/pi/.config/autostart/
tar -xvzf /home/pi/Backgrounds/Backgrounds.tar.gz -C /home/pi/Backgrounds/
tar -xvzf /usr/share/fonts/fonts.tar.gz -C /usr/share/fonts/

sudo update-alternatives --install /usr/bin/x-session-manager x-session-manager /usr/bin/startxfce4 60

curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/scripts/theme_switcher/first.desktop >>/home/pi/.config/autostart/first.desktop
curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/scripts/theme_switcher/first_theme.sh >>/opt/Radio-VNC/first_theme.sh
