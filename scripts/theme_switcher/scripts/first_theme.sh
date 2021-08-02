#!/bin/bash

source /opt/Radio-VNC/functions.sh
pwd=$(pwd)
errors=0

#Checks if this script is located in /opt/Radio-VNC
if [ $pwd -ne "/opt/Radio-VNC/" ]; then
  echo "This script must be located in /opt/Radio-VNC."
  errors=$((errors + 1))
fi

#Checks if the directory /usr/share/ThemeSwitcher exists
if [ ! -f /usr/share/ThemeSwitcher/ ]; then
  echo "/usr/share/ThemeSwitcher does not exist."
  echo "Please reinstall ThemeSwitcher"
  errors=$((errors + 1))
fi

#checks how many errors there were. If errors is equal to 0 then continue else exit
if [ $errors == 0 ]; then
  /usr/share/ThemeSwitcher/ThemeSwitcher
else
  echo "There was an error in the ThemeSwitcher config"
fi

rm ~/.config/autostart/first.desktop