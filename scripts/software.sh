#!/bin/bash

USER=pi
Config=/home/$USER/.config

selection=$(whiptail --title "Test" --separate-output --checklist Choose:"" 20 30 15 \
  "gqrx-sdr" "" on \
  "cubicsdr" "" off \
  "cutesdr" "" off \
  "qusik" "" off \
  3>&1 1>&2 2>&3)


if [[ $selection =~ "gqrx" ]]; then
  gqrx &
  /usr/bin/loading_screen.sh --gqrx
fi

if [[ $selection =~ "cubicsdr" ]]; then
  CubicSDR %u &
  /usr/bin/loading_screen.sh --cubicsdr
fi

if [[ $selection =~ "cutesdr" ]]; then
  CuteSdr &
  /usr/bin/loading_screen.sh --cutesdr
fi

if [[ $selection =~ "quisk" ]]; then
  quisk &
  /usr/bin/loading_screen.sh --quisk
fi
