#!/bin/bash

source /opt/Radio-VNC/functions.sh

terminal_window_id=`xdotool getactivewindow`
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

gqrx_load(){
while true
do
    TERM=vt220 whiptail --infobox "Loading GQRX\nPlease Wait" "${r}" "${c}"

    # get list of windows
    windows=$(wmctrl -l)
    # check if window is on the list
    if [[ "$windows" =~ "Gqrx" ]];
    then
       xdotool windowminimize $terminal_window_id
       break
    fi
    # delay until next loop iteration
    sleep 3
done
}

cubicsdr_load(){
while true
do
    TERM=vt220 whiptail --infobox "Loading CubicSDR\nPlease Wait" "${r}" "${c}"

    # get list of windows
    windows=$(wmctrl -l)
    # check if window is on the list
    if [[ "$windows" =~ "CubicSDR" ]];
    then
       xdotool windowminimize $terminal_window_id
       break
    fi
    # delay until next loop iteration
    sleep 3
done
}

cutesdr_load(){
while true
do
    TERM=vt220 whiptail --infobox "Loading CuteSdr\nPlease Wait" "${r}" "${c}"

    # get list of windows
    windows=$(wmctrl -l)
    # check if window is on the list
    if [[ "$windows" =~ "CuteSdr" ]];
    then
       xdotool windowminimize $terminal_window_id
       break
    fi
    # delay until next loop iteration
    sleep 3
done
}

quisk_load(){
while true
do
    TERM=vt220 whiptail --infobox "Loading quisk\nPlease Wait" "${r}" "${c}"

    # get list of windows
    windows=$(wmctrl -l)
    # check if window is on the list
    if [[ "$windows" =~ "Quisk" ]];
    then
       xdotool windowminimize $terminal_window_id
       break
    fi
    # delay until next loop iteration
    sleep 3
done
}

while [ "$1" != "" ]; do
    case $1 in
    --quisk | quisk)
        quisk_load
        ;;
    --cutesdr | cutesdr)
        cutesdr_load
        ;;
    --cubicsdr | cubicsdr)
        cubicsdr_load
        ;;
    --gqrx | gqrx)
        gqrx_load
        ;;
    *)
        usage
        exit 1
        ;;
    esac
    shift # remove the current value for `$1` and use the next
done
