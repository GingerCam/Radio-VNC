#!/usr/bin/env python3

import sys
import os
sys.path.append(os.getcwd())
import termcolor
from radiovnc.core.config.settings import *
from time import sleep
programs = {
    0: "gqrx",
    1: "xwxtoimg",
    2: "CuteSdr",
    3: "CubicSDR",
    4: "quisk",
    5: sys.exit,
    }

def intro():
    os.system("clear")
    os.system(("figlet Radio-VNC"))
    print("mode=sdr")
    print(version)
    print()

def exe(cmd):
    print(f"Loading {cmd}")
    os.system(cmd + " >/dev/null 2>&1 &")
    sleep(5)
    sdr_main()

def sdr_main():
    intro()

    print("""[0] GQRX\n[1] wxtoimg\n[2] CuteSDR\n[3] CubicSDR\n[4] Quisk\n[5] Exit\n""")
    while True:
        try:
            selection = int(input(termcolor.colored("radiovnc> ")))
        except ValueError:
            print("Input must be a number")
        else:
            if 0 <= selection < 5:
                num = programs.get(selection)
                exe(num)
                break
            else:
                print("number out of range")
    

if __name__ == '__main__':
    try:
        sdr_main()
    except KeyboardInterrupt:
        sys.exit()