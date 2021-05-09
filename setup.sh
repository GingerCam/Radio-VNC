#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   whiptail --msgbox "This script must be run as root" 8 78
   exit 1
fi

if (whiptail --title "Radio-VNC installation script" --yesno "Would you like to install Radio-VNC?" 8 78); then
    return
else
    exit 1
fi

USER=${SUDO_USER:-$(who -m | awk '{ print $1 }')}
branch=dev
config=/home/$USER/.config
CURRENT_HOSTNAME=`cat /etc/hostname | tr -d " \t\n\r"`
NEW_HOSTNAME=Radio-VNC

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

whiptail --msgbox "Radio-VNC written by GingerCam https://github.com/GingerCam" 8 78


echo "Radio-VNC will install hostapd, dnsmasq, GQRX, pixel desktop, vnc-server and all of their dependencies."

apt update && apt upgrade -y
apt install -y hostapd dnsmasq gqrx-sdr raspberrypi-ui-mods curl wget realvnc-vnc-server realvnc-vnc-viewer figlet lxappearance arc-theme

echo "Config files will be downloaded"

mkdir -p /home/$USER/.config/autostart /home/$USER/.config/lxsession/LXDE-pi /home/$USER/.config/pcmanfm/LXDE-pi
chown $USER:$USER /home/$USER/.config
curl  https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/config/dhcpcd.conf -o /etc/dhcpcd.conf
curl  https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/config/dnsmasq.conf -o /etc/dnsmasq.conf
curl  https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/config/hostapd.conf -o /etc/hostapd/hostapd.conf
curl  https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/config/desktop.conf -o $config/lxsession/LXDE-pi/desktop.conf

echo "Config files have been downloaded"
sleep 1

echo "Setting up applications"
echo ""DAEMON_CONF="/etc/hostapd/hostapd.conf" >> "/etc/default/hostapd"
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo ""

echo "Setting up wireless location to GB"
wpa_cli -i wlan0 set country GB
wpa_cli -i wlan0 save_config > /dev/null 2>&1
rfkill unblock wifi
for filename in /var/lib/systemd/rfkill*:wlan ; do
  echo 0 > $filename
done
sleep 1
echo "Set"

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
echo "
"
echo "Setting up GQRX to start on boot"
sleep 1
curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/other-files/gqrx.desktop -o $config/autostart/gqrx.desktop
echo "Set"

echo "Network==Radio-VNC | Network-Password==RaspberryRadio | ip address==192.168.4.1 | hostname==Radio-VNC" >> /home/$USER/info.txt
echo "Check /home/$USER/info.txt for more infomation"
sleep 2
echo ""
echo ""
echo "Setting desktop wallpaper"
wget -O /home/$USER/background.png "https://github.com/GingerCam/Radio-VNC/raw/$branch/other-files/background.png"
curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/config/desktop-items-0.conf -o $config/pcmanfm/LXDE-pi/desktop-items-0.conf
chown pi:pi $config/pcmanfm/LXDE-pi/desktop-items-0.conf
echo "Set"
sleep 1
echo ""
sed /etc/lightdm/lightdm.conf -i -e "s/^\(#\|\)autologin-user=.*/autologin-user=$USER/"
echo "Changing hostname to Radio-VNC"
sleep 1
echo $NEW_HOSTNAME > /etc/hostname
sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\t$NEW_HOSTNAME/g" /etc/hosts
echo "Set"

curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/other-files/update-script.sh -o /usr/bin/update-script.sh
curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/setup.sh -o /usr/bin/script.sh

crontab -l > mycron
echo "@reboot /usr/bin/update.sh" >> mycron
curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/update.sh -o /usr/bin/update.sh
crontab mycron
rm mycron

whiptail --msgbox "Radio-VNC is installed" 8 78
whiptail --msgbox "System will reboot in 5 seconds" 8 78
sleep 5
reboot
