# Radio-VNC
Radio-VNC is a project that allows you to control an SDR with your phone, you can control your pi by connecting to phone or laptop to the WI-FI network produced by the pi. Secondly you use a VNC client to connect to the Pi's IP address (192.168.4.1)
It is recommended to change the default password for the Pi user.
It uses GQRX to control the SDR and hostapd and dnsmasq for the access point

# Requirements
Any Raspberry Pi (The later ones are strongly recommended, as SDR's use a bit of CPU)

A USB SDR

An aerial (For better reception)

An active internet connection (For the setup process)

A wireless interface (For the WI-FI network)

Raspberry Pi OS lite installed on the pi

a 32gb sd card (16gb might work)

# Easy install on Raspberry Pi

First you need to install Raspberry Pi OS lite to an SD card, then boot it up and execute the command:

"curl https://raw.githubusercontent.com/GingerCam/Radio-VNC/main/setup.sh | sudo bash"

This project is being actively worked on by myself (GingerCam) and any feedback is greatly appreciated.

It is recommended to install to a new SD card or USB drive so you don't loose any data.

# Update Radio-vnc

To update Radio-VNC a script auto checks for updates on boot through crontab.

The scripts are stored at /usr/bin/update.sh /usr/bin/update-script.sh and the .desktop file is stored on GitHub in /other-files/

# Uninstalling Radio-vnc

To uninstall Radio-VNC you can execute the command:

"sudo bash /usr/bin/uninstall.sh"

This will uninstall Radio-VNC and all of its dependencies

# radiovnc cli

There will be a new CLI for radiovnc to configure Wi-Fi and Bluetooth and other things that i haven't had the idea for yet

The cli will look like the example:

"sudo radiovnc-wifi"

"sudo radiovnc-samba"

radiovnc- then the thing to configure

# GitHub branches

The "main" branch is for stable and standard use.

The "dev" branch is for testing and is mostly unstable and dysfunctional, so if you aren't a tester or tech "nerd" then i would keep away. But i'm not stopping you from looking at it, so go ahead.

# THEMES

I will be adding new themes and a new theme selector. The themes will include Windows (11, 10, 7, XP, 95), MacOS/Big Sur. If there is any you would like to be seen added then make an issue and give the label enhancement.   
