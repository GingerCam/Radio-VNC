# Radio-VNC
Radio-VNC is a project that allows you to control an SDR with your phone, you can control your pi by connecting to phone or laptop to the WI-FI network produced by the pi. Secondly you use a VNC client to connect to the Pi's IP address (192.168.4.1)
It is recommended to change the default password for the Pi user.
It uses GQRX to control the SDR and hostapd and dnsmasq for the access point

# Requirements
Any Raspberry Pi (The later ones are preferable, as SDR's use a bit of CPU)

A USB SDR

An aerial (For better reception)

An active internet connection (For the setup process)

A wireless interface (For the WI-FI network)

Raspberry Pi OS lite installed on the pi

# Easy install on Raspberry Pi

First you need to install Raspberry Pi OS lite to an SD card, then boot it up and execute the command:

"curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/main/setup.sh | sudo bash"

This project is being actively worked on by myself (GingerCam) and any feedback is greatly appreciated.

It is recommended to install to a new SD card or USB drive so you don't loose any data.

# To do list

Add an uninstall script

Maybe make it an application rather than consuming a whole SD card for this project
