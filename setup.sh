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

#USER=${SUDO_USER:-$(who -m | awk '{ print $1 }')}
USER=pi
branch=dev
config=/home/$USER/.config
CURRENT_HOSTNAME=`cat /etc/hostname | tr -d " \t\n\r"`
NEW_HOSTNAME=Radio-VNC
wireless_interface=`iw dev | awk '$1=="Interface"{print $2}'`
webroot="/var/www/html"
RADIO_VNC_LOCAL_REPO="/etc/.radiovnc"

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

is_command() {
    # Checks to see if the given command (passed as a string argument) exists on the system.
    # The function returns 0 (success) if the command exists, and 1 if it doesn't.
    local check_command="$1"

    command -v "${check_command}" >/dev/null 2>&1
}

whiptail --msgbox "Radio-VNC written by GingerCam https://github.com/GingerCam" "${r}" "${c}"

optional=$(whiptail --title "Test" --checklist Choose: "${r}" "${c}" \
  "gqrx-sdr" "" on \
  "rtl-sdr" "" off \
  "cutesdr" "" off \
  "qusik" "" off \
  "lysdr" "" off \
  3>&1 1>&2 2>&3)

  if (whiptail --title "Argon One case" --defaultno --yesno "If you have an Argon One case you might want to install the Argon One script.\nWould you like to install it?" "${r}" "${c}"); then
    Argon=TRUE
  else
    ARGON=FALSE
  fi

echo "Radio-VNC will install hostapd, dnsmasq, GQRX, pixel desktop, vnc-server and all of their dependencies."

apt update && apt upgrade -y
apt install -y hostapd dnsmasq raspberrypi-ui-mods curl wget realvnc-vnc-server realvnc-vnc-viewer figlet lxappearance arc-theme terminator
apt install $optional

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

if grep -q "DAEMON_CONF="/etc/hostapd/hostapd.conf"" /etc/default/hostapd; then
  return
else
  echo ""DAEMON_CONF="/etc/hostapd/hostapd.conf" >> "/etc/default/hostapd"
fi

if grep -q "^net.ipv4.ip_forward=1" /etc/sysctl.conf; then
  return
else
  sed -i "s/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/" /etc/sysctl.conf
fi

echo ""

echo "Setting up wireless location to GB"
wpa_cli -i $wireless_interface set country GB
wpa_cli -i $wireless_interface save_config > /dev/null 2>&1
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
echo ""

echo "Setting up Software Selector to start on boot"
sleep 1
curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/other-files/software.desktop -o $config/autostart/software.desktop
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

if grep -q "^autologin-user=" /etc/lightdm/lightdm.conf ; then
  return
else
  sed /etc/lightdm/lightdm.conf -i -e "s/^\(#\|\)autologin-user=.*/autologin-user=$USER/"
fi

echo "Changing hostname to Radio-VNC"
sleep 1

if grep -q "127.0.1.1 Radio-VNC" /etc/hosts; then
  return
else
  echo $NEW_HOSTNAME > /etc/hostname
  sed -i "s/127.0.1.1.*$CURRENT_HOSTNAME/127.0.1.1\t$NEW_HOSTNAME/g" /etc/hosts
fi

echo "Set"

curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/scripts/update-script.sh -o /usr/bin/update-script.sh
curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/setup.sh -o /usr/bin/script.sh
curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/uninstall.sh -o /usr/bin/uninstall.sh
curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/software.sh -o /usr/bin/software.sh

crontab -l > mycron

if grep -q "@reboot /usr/bin/update.sh" mycron ; then
  return
else
  echo "@reboot /usr/bin/update.sh" >> mycron
  crontab mycron
fi

curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/$branch/update.sh -o /usr/bin/update.sh
rm mycron
chmod +x /usr/bin/update.sh /usr/bin/update-script.sh /usr/bin/script.sh /usr/bin/uninstall.sh /usr/bin/software.sh

if [ "$ARGON"=TRUE ]; then
  curl https://download.argon40.com/argon1.sh | bash
else
  return
fi
git clone https://github.com/GingerCam/Radio-VNC.git /opt/Radio-VNC

whiptail --msgbox "Radio-VNC is installed" "${r}" "${c}"
whiptail --msgbox "System will reboot in 5 seconds" "${r}" "${c}"
sleep 5
reboot
