#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root"
   exit 1
fi


branch=dev


echo "Radio-VNC written by GingerCam https://github.com/GingerCam"
echo ""
sleep 1
echo "You are about to install Radio-VNC"
echo "Do you want to continue?"
echo "Press CTRL + C in the next 10 seconds to cancel"
sleep 10

echo "Radio-VNC will install hostapd, dnsmasq, GQRX, pixel desktop, vnc-server and all of their dependencies."

apt update && apt upgrade -y
apt install -y hostapd dnsmasq gqrx-sdr raspberrypi-ui-mods curl wget realvnc-vnc-server realvnc-vnc-viewer figlet lxappearance arc-theme

echo "Config files will be downloaded"

mkdir -p /home/pi/.config/autostart /home/pi/.config/lxsession/LXDE-pi
chown pi:pi /home/pi/.config
curl  https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/config/dhcpcd.conf -o /etc/dhcpcd.conf
curl  https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/config/dnsmasq.conf -o /etc/dnsmasq.conf
curl  https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/config/hostapd.conf -o /etc/hostapd/hostapd.conf
curl  https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/config/desktop.conf -o /home/pi/.config/lxsession/LXDE-pi/desktop.conf

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

echo "Setting up ssh server"
ssh-keygen -A
update-rc.d ssh enable
invoke-rc.d ssh start
echo ""
echo "ssh server is configured"

echo "Setting up hostapd"
sleep 1
systemctl unmask hostapd
systemctl enable hostapd
echo "Set"

echo "Changing hostname to Radio-VNC"
sleep 1
hostnamectl set-hostname 'Radio-VNC'
echo "Set"

echo "Setting up GQRX to start on boot"
sleep 1
curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/other-files/gqrx.desktop -o /home/pi/.config/autostart/gqrx.desktop
echo "Set"

echo "Network==Radio-VNC | Network-Password==RaspberryRadio | ip address==192.168.4.1 | hostname==Radio-VNC" >> /home/pi/info.txt
echo "Check /home/pi/info.txt for more infomation"
sleep 2
echo ""
echo ""
echo "Setting desktop wallpaper"
wget -O /home/pi/background.png "https://github.com/GingerCam/Radio-VNC/raw/$branch/other-files/background.png"
runuser -u pi "pcmanfm --set-wallpaper /home/pi/background.png"
echo "Set"
sleep 1
echo "autologin-guest=false" >> /etc/lightdm/lightdm.conf
echo "autologin-user=pi" >> /etc/lightdm/lightdm.conf
echo "autologin-user-timeout=0" >> /etc/lightdm/lightdm.conf

figlet Radio-VNC is installed
echo "System will reboot in 5 seconds"
sleep 5
reboot
