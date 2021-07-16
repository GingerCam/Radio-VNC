#!/bin/bash

#check for root
if [[ $EUID -ne 0 ]]; then
   whiptail --msgbox "This script must be run as root" 8 78
   exit 1
fi

#confirmation
if (whiptail --title "Radio-VNC installation script" --yesno "Would you like to install Radio-VNC?" 8 78); then
    echo 0
else
    exit 1
fi

mkdir /mnt > /dev/null 2>&1

#variables
USER=pi
branch=dev
config=/home/$USER/.config
CURRENT_HOSTNAME=`cat /etc/hostname | tr -d " \t\n\r"`
NEW_HOSTNAME=Radio-VNC
wireless_interface=`iw dev | awk '$1=="Interface"{print $2}'`
radiovnc_conf=/etc/radiovnc.conf
mkdir /opt/Radio-VNC > /dev/null 2>&1
chown $USER:$USER /opt/Radio-VNC > /dev/null 2>&1
curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/other-files/functions.sh -o /opt/Radio-VNC/functions.sh > /dev/null 2>&1
source /opt/Radio-VNC/functions.sh

#get terminal size
if [ -t 0 ] ; then
  screen_size=$(stty size)
else
  screen_size="24 80"
fi

printf -v rows '%d' "${screen_size%% *}"
printf -v columns '%d' "${screen_size##* }"

# Divide by two so the dialogs take up half of the screen, which looks nice.
r=$(( rows / 2 ))
c=$(( columns / 2 ))
# Unless the screen is tiny
r=$(( r < 20 ? 20 : r ))
c=$(( c < 70 ? 70 : c ))


whiptail --msgbox "Radio-VNC written by GingerCam https://github.com/GingerCam" "${r}" "${c}"

#argon setup
  if (whiptail --title "Argon One case" --defaultno --yesno "If you have an Argon One case you might want to install the Argon One script.\nWould you like to install it?" "${r}" "${c}"); then
    Argon=TRUE
  else
    ARGON=FALSE
  fi

echo "Radio-VNC will install hostapd, dnsmasq, GQRX, pixel desktop, vnc-server and all of their dependencies."
#install packages
apt update && apt upgrade -y
apt install -y hostapd dnsmasq raspberrypi-ui-mods curl wget realvnc-vnc-server realvnc-vnc-viewer figlet lxappearance arc-theme terminator samba samba-common-bin wmctrl
apt install gqrx-sdr rtl-sdr cutesdr quisk lysdr

#config files
echo "Config files will be downloaded"
mkdir -p /home/$USER/.config/autostart /home/$USER/.config/lxsession/LXDE-pi /home/$USER/.config/pcmanfm/LXDE-pi
chown $USER:$USER /home/$USER/.config
curl  https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/config/dhcpcd.conf -o /etc/dhcpcd.conf
curl  https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/config/dnsmasq.conf -o /etc/dnsmasq.conf
curl  https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/config/hostapd.conf -o /etc/hostapd/hostapd.conf
curl  https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/config/desktop.conf -o $config/lxsession/LXDE-pi/desktop.conf

echo "Config files have been downloaded"
sleep 1

#setting up wireless settings
echo "Setting up applications"

if grep -q "DAEMON_CONF="/etc/hostapd/hostapd.conf"" /etc/default/hostapd; then
  echo 1
else
  echo ""DAEMON_CONF="/etc/hostapd/hostapd.conf" >> "/etc/default/hostapd"
fi

if grep -q "^net.ipv4.ip_forward=1" /etc/sysctl.conf; then
  echo 1
else
  sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/" /etc/sysctl.conf
fi
echo ""

#setting wireless country
echo "Setting up wireless location to GB"
wpa_cli -i $wireless_interface set country GB
wpa_cli -i $wireless_interface save_config > /dev/null 2>&1
rfkill unblock wifi
for filename in /var/lib/systemd/rfkill*:wlan ; do
  echo 0 > $filename
done
sleep 1
echo "Set"

#set up applications
echo "Setting up VNC server"
systemctl enable vncserver-x11-serviced.service
systemctl start vncserver-x11-serviced.service
echo ""
sleep 1
echo "VNC server is configured"
echo ""

echo "Setting up ssh server"
ssh-keygen -A
update-rc.d ssh enable
invoke-rc.d ssh start
echo ""
echo "ssh server is configured"
echo ""

echo "Setting up hostapd"
systemctl unmask hostapd
systemctl enable hostapd
sleep 1
echo "Set"
echo ""

#start on boot
echo "Setting up Software Selector to start on boot"
sleep 1
curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/other-files/software.desktop -o $config/autostart/software.desktop
echo "Set"

echo "Network==RPI-Radio | Network-Password==RaspberryRadio | ip address==192.168.4.1 | hostname==Radio-VNC" >> /home/$USER/info.txt
echo "Check /home/$USER/info.txt for more infomation"
sleep 2
echo ""
echo ""

#wallpaper
echo "Setting desktop wallpaper"
wget -O /home/$USER/Pictures/big_image.png "https://github.com/GingerCam/Radio-VNC/raw/$branch/other-files/images/big_image.png"
wget -O /home/$USER/Pictures/small_image.png "https://github.com/GingerCam/Radio-VNC/raw/$branch/other-files/images/small_image.png"
wget -O /home/$USER/Pictures/very_small_image.png "https://github.com/GingerCam/Radio-VNC/raw/$branch/other-files/images/very_small_image.png"
curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/config/items-0.conf -o $config/pcmanfm/LXDE-pi/desktop-items-0.conf
chown pi:pi $config/pcmanfm/LXDE-pi/desktop-items-0.conf
echo "Set"
sleep 1
echo ""

#autologin
if grep -q "^autologin-user=" /etc/lightdm/lightdm.conf ; then
  echo 1
else
  sed /etc/lightdm/lightdm.conf -i -e "s/^\(#\|\)autologin-user=.*/autologin-user=$USER/"
fi

#hostname
echo "Changing hostname to Radio-VNC"
sleep 1

if grep -q "127.0.1.1 Radio-VNC" /etc/hosts; then
  echo 1
else
  echo $NEW_HOSTNAME > /etc/hostname
  sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\t$NEW_HOSTNAME/g" /etc/hosts
fi

echo "Set"

#scripts
script_files="update.sh setup.sh uninstall.sh"
for file in $script_files; do
  curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/$file -o /usr/bin/$file &>/dev/null
  chmod +x /usr/bin/$file
done

script_files1="update-script.sh software.sh screen_resolution.sh loading_screen.sh"
for file in $script_files1; do
  curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/scripts/$file -o /usr/bin/$file &>/dev/null
  chmod +x /usr/bin/$file
done

curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/config/radiovnc.conf -o /etc/radiovnc.conf
curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/other-files/autousb.service -o /etc/systemd/system/autousb.service

cli_files="radiovnc-wifi radiovnc-samba radiovnc-autousb"
for file in $cli_files; do
  curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/scripts/cli_program/$file -o /usr/bin/$file
  chown $USER:$USER /usr/bin/$file
  chmod +x /usr/bin/$file
done
curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/update.sh -o /usr/bin/update.sh
rm mycron
chmod +x /usr/bin/update.sh /usr/bin/update-script.sh /usr/bin/setup.sh /usr/bin/uninstall.sh /usr/bin/software.sh

#crontab
crontab -l > mycron
if grep -q "@reboot /usr/bin/update.sh" mycron ; then
  echo 1
else
  echo "@reboot /usr/bin/update.sh" >> mycron
  crontab mycron
fi

if grep -q "@reboot /usr/bin/screen_resolution.sh" mycron ; then
  echo 1
else
  echo "@reboot /usr/bin/screen_resolution.sh" >> mycron
  crontab mycron
fi

#argon setup
if [ "$ARGON"=TRUE ]; then
  curl https://download.argon40.com/argon1.sh | bash
fi

#config samba
samba_config

whiptail --msgbox "Radio-VNC is installed" "${r}" "${c}"
whiptail --msgbox "System will reboot in 5 seconds" "${r}" "${c}"
sleep 5
reboot
