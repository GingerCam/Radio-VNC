#!/bin/bash

USER=pi
Config=/home/$USER/.config

selection=$(whiptail --title "Test" --separate-output --checklist Choose:"" 20 30 15 \
  "gqrx-sdr" "" on \
  "cubicsdr" "" off \
  "cutesdr" "" off \
  "qusik" "" off \
  "lysdr" "" off \
  3>&1 1>&2 2>&3)


if [[ $selection == *"gqrx"* ]]; then
  gqrx &
fi

if [[ $selection == *"cubicsdr"* ]]; then
  CubicSDR %u &
fi

if [[ $selection == *"cutesdr"* ]]; then
  CuteSdr &
fi

if [[ $selection == *"quisk"* ]]; then
  quisk &
fi

if [[ $selection == *"lysdr"* ]]; then
  lysdr &
fi
