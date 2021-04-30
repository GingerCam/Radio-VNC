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

echo "Radio-VNC will install hostapd, dnsmasq, GQRX, pixel desktop and all of their dependencies."

apt update && apt upgrade -y 
apt install -y hostapd dnsmasq gqrx-sdr raspberrypi-ui-mods curl wget

echo "Config files will be downloaded"

curl  https://raw.githubusercontent.com/GingerCam/Radio-VNC/main/config/dhcpcd.conf -o /etc/dhcpcd.conf
curl  https://raw.githubusercontent.com/GingerCam/Radio-VNC/main/config/dnsmasq.conf -o /etc/dnsmasq.conf
curl  https://raw.githubusercontent.com/GingerCam/Radio-VNC/main/config/hostapd.conf -o /etc/hostapd/hostapd.conf

echo ""DAEMON_CONF="/etc/hostapd/hostapd.conf" >> "/etc/defaults/hostapd"
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf


