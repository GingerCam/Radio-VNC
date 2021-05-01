#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

echo "Radio-VNC written by GingerCam https://github.com/GingerCam"
echo ""
sleep 1
echo "You are about to install Radio-VNC"
echo "Do you want to continue?"
echo "Press CTRL + C in the next 10 seconds to cancel"
sleep 10

echo "Radio-VNC will install hostapd, dnsmasq, GQRX, pixel desktop, vnc-server and all of their dependencies."

apt update && apt upgrade -y 
apt install -y hostapd dnsmasq gqrx-sdr raspberrypi-ui-mods curl wget realvnc-vnc-server realvnc-vnc-viewer figlet



echo "Config files will be downloaded"

curl  https://raw.githubusercontent.com/GingerCam/Radio-VNC/main/config/dhcpcd.conf -o /etc/dhcpcd.conf
curl  https://raw.githubusercontent.com/GingerCam/Radio-VNC/main/config/dnsmasq.conf -o /etc/dnsmasq.conf
curl  https://raw.githubusercontent.com/GingerCam/Radio-VNC/main/config/hostapd.conf -o /etc/hostapd/hostapd.conf

echo "Config files have been downloaded"
sleep 1

echo "Setting up applications"
echo ""DAEMON_CONF="/etc/hostapd/hostapd.conf" >> "/etc/default/hostapd"
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
echo "sudo -u pi vncserver -randr=1400x900" >> /etc/rc.local
echo ""

echo "Setting up hostapd"
sleep 1
systemctl unmask hostapd
systemctl enable hostapd

echo "Changing hostname to Radio-VNC"
sleep 1
hostnamectl set-hostname 'Radio-VNC'

echo "Setting up GQRX to start on boot"
sleep 1
mkdir /home/pi/.config/autostart
curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/main/other-files/gqrx.desktop -o /home/pi/.config/autostart/gqrx.desktop

echo "Network==Radio-VNC | Network-Password==RaspberryRadio | ip address==192.168.4.1 | hostname==Radio-VNC" >> /home/pi/info.txt
echo "Check /home/pi/info.txt for more infomation"
sleep 2
echo ""
echo ""

figlet Radio-VNC is installed
echo "System will reboot in 5 seconds"
sleep 5
reboot