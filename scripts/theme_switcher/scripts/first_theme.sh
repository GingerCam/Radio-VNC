#!/bin/bash

source /opt/Radio-VNC/functions.sh
pwd=`pwd`
errors=0

if [ $pwd -ne /opt/Radio-VNC/ ]; then
  echo "This script must be located in /opt/Radio-VNC."
  errors=$((errors + 1))
  
fi

if [ ! -f /usr/share/ThemeSwitcher/ ]; then
  echo "/usr/share/ThemeSwitcher does not exist."
  echo "Please reinstall ThemeSwitcher"
  errors=$((errors + 1))
fi 

if [ $errors == 0 ]; then
  /usr/share/ThemeSwitcher/ThemeSwitcher
fi
