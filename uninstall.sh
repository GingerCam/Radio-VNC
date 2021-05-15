#!/usr/bin/env bash

if [[ $EUID -ne 0 ]]; then
   whiptail --msgbox "This script must be run as root" 8 78
   exit 1
fi

USER=pi
branch=dev
config=/home/$USER/.config
CURRENT_HOSTNAME=`cat /etc/hostname | tr -d " \t\n\r"`
NEW_HOSTNAME=raspberrypi

is_pi () {
  ARCH=$(dpkg --print-architecture)
  if [ "$ARCH" = "armhf" ] || [ "$ARCH" = "arm64" ] ; then
    return 0
  else
    return 1
  fi
}

if is_pi ; then
  CMDLINE=/boot/cmdline.txt
else
  CMDLINE=/proc/cmdline
fi

if (whiptail --title "Radio-VNC uninstall script" --yesno "Are you sure you want to uninstall Radio-VNC?\nWARNING:This will uninstall Radio-VNC and all of it's dependencies" 8 78); then
  return 0
else
  exit 1
fi

apt purge -y hostapd dnsmasq gqrx-sdr raspberrypi-ui-mods realvnc-vnc-server realvnc-vnc-viewer figlet lxappearance arc-theme terminator
apt autoremove

rm -rf $config /home/$USER/background.png /usr/bin/update.sh /usr/bin/update-script.sh /usr/bin/script.sh /home/$USER/info.txt

if grep -q "127.0.1.1 Radio-VNC" /etc/hosts; then
  echo $NEW_HOSTNAME > /etc/hostname
  sed -i "s/127.0.1.1.*$NEW_HOSTNAME/127.0.1.1\t$CURRENT_HOSTNAME/g" /etc/hosts
else
  return
fi

crontab -l > mycron

if grep -q "@reboot /usr/bin/update.sh" mycron ; then
  sed -i "s/@reboot/#@reboot/ mycron"
  crontab mycron
  rm mycron
else
  return
fi

update-rc.d ssh disable
update-rc.d ssh stop

if grep -q "^net.ipv4.ip_forward=1" /etc/sysctl.conf; then
  sed -i "s/net.ipv4.ip_forward=1/#net.ipv4.ip_forward=1/" /etc/sysctl.conf
else
  return
fi
whiptail --msgbox "Radio-VNC has been uninstalled" 20 70 0
whiptail --msgbox "Goodbye, I hope you have enjoyed Radio-VNC" 20 70 0
whiptail --msgbox "Have Fun On Your New Raspberry Pi Project" 20 70 0
whiptail --msgbox "Sincerely,\nThe Radio-VNC Devs" 20 70 0
reboot
