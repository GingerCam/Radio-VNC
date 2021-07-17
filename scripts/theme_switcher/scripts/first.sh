#!/bin/bash

source /opt/Radio-VNC/functions.sh

if [(pwd) -ne /opt/Radio-VNC/]; then
  echo "This script must be located in /opt/Radio-VNC."
fi

if [ -f /usr/share/ThemeSwitcher/ ]; then
  echo 1 
fi 