#!/usr/share/env python3

import configparser
import sys
import os

config_file = "radiovnc/core/config/settings.txt"
config = configparser.ConfigParser()
config.read_file(open(config_file))

version = config.get("version", "version")

