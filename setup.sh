#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

echo "Radio-VNC written by GingerCam https://github.com/GingerCam"
echo "You are about to install Radio-VNC"
echo "Do you want to continue?"
echo "Press CTRL + C in the next 10 seconds to cancel"
sleep 10

echo "Radio-VNC will install hostapd, dnsmasq, GQRX, pixel desktop, vnc-server and all of their dependencies."

apt update && apt upgrade -y 
apt install -y hostapd dnsmasq gqrx-sdr raspberrypi-ui-mods curl wget realvnc-vnc-server realvnc-vnc-viewer



echo "Config files will be downloaded"

curl  https://raw.githubusercontent.com/GingerCam/Radio-VNC/main/config/dhcpcd.conf -o /etc/dhcpcd.conf
curl  https://raw.githubusercontent.com/GingerCam/Radio-VNC/main/config/dnsmasq.conf -o /etc/dnsmasq.conf
curl  https://raw.githubusercontent.com/GingerCam/Radio-VNC/main/config/hostapd.conf -o /etc/hostapd/hostapd.conf

echo ""DAEMON_CONF="/etc/hostapd/hostapd.conf" >> "/etc/default/hostapd"
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo "sudo -u pi vncserver -randr=1400x900" >> /etc/rc.local
systemctl unmask hostapd
update-rc.d hostapd enable
hostnamectl set-hostname 'Radio-VNC'

echo"
Network==Radio-VNC
ip address==192.168.4.1
hostname==Radio-VNC
" >> /home/pi/info.txt

echo "Radio-VNC is installed"
echo "System will reboot in 5 seconds"
sleep 5
reboot
