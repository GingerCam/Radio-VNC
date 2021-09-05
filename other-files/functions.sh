#!/bin/bash

if [[ -d "/opt/Radio-VNC/functions/" ]]; then
    for file in /opt/Radio-VNC/functions/*.sh; do
        source $file
    done
else
    echo "Functions folder doesn't exist"
fi
