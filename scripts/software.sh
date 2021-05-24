#!bin/bash

USER=pi
Config=/home/$USER/.config

selection=$(whiptail --title "Test" --separate-output --checklist Choose:" 20 30 15 \
  "gqrx" "" on \
  "cubicsdr" "" off \
  "cutesdr" "" off \
  "qusik" "" off \
  "lysdr" "" off \
  3>&1 1>&2 2>&3)


bash $selection