#!/bin/bash

USER=pi
Config=/home/$USER/.config

sleep 1
#get terminal size
if [ -t 0 ] ; then
  screen_size=$(stty size)
else
  screen_size="24 80"
fi

printf -v rows '%d' "${screen_size%% *}"
printf -v columns '%d' "${screen_size##* }"

# Divide by two so the dialogs take up half of the screen, which looks nice.
r=$(( rows / 2 ))
c=$(( columns / 2 ))
# Unless the screen is tiny
r=$(( r < 20 ? 20 : r ))
c=$(( c < 70 ? 70 : c ))

selection=$(whiptail --title "Test" --separate-output --checklist Choose:"" "${r}" "${c}" \
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
