#!/usr/bin/env python3

# import statements
import configparser
import sys
import os
import time
from radiovnc.core.config.settings import *
from radiovnc.controllers.sdr import programs, exe, sdr_main
import urllib.request

hotspot=None
version=None
ssh=None
vnc=None
smb=None

# variables
radiovnc_dir = "/usr/share/Radio-VNC/"
config_file = "/opt/Radio-VNC/radiovnc.conf"

# function to check for internet access
def internet_access():
    try:
        urllib.request.urlopen("http://google.com") 
        return True
    except:
        return False

# checks the output of function internet_access()
if internet_access() == True:   
    internet_access = True
else:
    internet_access = False

# gets the config from /opt/Radio-VNC/radiovnc.conf
def getconfig():
    config = configparser.ConfigParser()
    version = config.get("version", "version")
    hotspot = config.get("radiovnc", "hotspot")
    ssh = config.get("services", "ssh")
    vnc = config.get("services", "vnc")
    smb = config.get("services", "samba")