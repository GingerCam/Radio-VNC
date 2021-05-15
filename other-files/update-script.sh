#!/bin/bash

USER=${SUDO_USER:-$(who -m | awk '{ print $1 }')}
branch=dev

if (whiptail --title "Radio-VNC update script" --yesno "There is a later version of Radio-VNC available.\nWould you like to update?" 8 78); then
    return
else
    exit 1
fi

if (whiptail --title "Radio-VNC update script" --yesno "Radio-VNC will replace some config files, so if you have made any changes please back them up first.\nWould you like to continue" 8 78); then
  return
else
  exit 1
fi

psw=$(whiptail --title "Test Password Box" --passwordbox "Enter your password and choose Ok to continue." 10 60 3>&1 1>&2 2>&3)
    exitstatus=$?
  #statements
    if [ $exitstatus = 0 ]; then
        sudo -S <<< $psw curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/setup.sh | sudo bash
    else
        #Password If cancel
        whiptail --title "Cancel" --msgbox "Operation Cancel" 10 60
    fi


rm /home/$USER/.config/autostart/update.desktop
