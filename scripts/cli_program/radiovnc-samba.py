#!/usr/bin/env python3
import os, sys
#from radiovnc.core.config.settings import *
from termcolor import cprint

# def intro():
#     os.system("figlet Radio-VNC")
#     print("\nversion")

# def start():
#     print("Starting Samba server")
#     print("IP address is 192.168.4.1")
#     print("Waiting until CTRL + C ...")
#     os.system("sudo systemctl start smbd")

# def stop():
#     cprint("CTRL + C caught", "red")
#     cprint("stopping samba server", "red")
#     os.system("sudo systemctl stop smbd")
#     sys.exit()

# def stop_daemon():
#     cprint("Stopping samba daemon...")
#     os.system("sudo systemctl stop smbd")

# def main():
#     intro()
#     print("[0] Start Samba server daemon")
#     print("[1] Start Samba server until Ctrl + C is pressed")
#     print("[2] Stop samba daemon")

print(os.getcwd())