#!/bin/bash

source /opt/Radio-VNC/functions.sh

gqrx_load(){
while true
do
    TERM=vt220 whiptail --infobox "Please Wait" 0 0

    # get list of windows
    windows=$(wmctrl -l)
    # check if window is on the list
    if [[ "$windows" =~ "Gqrx" ]];
    then
       xdotool windowminimize $(xdotool getactivewindow)
       exit 1
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
    --cubicsdr | cubicsdr)
        cubicsdr_load
        ;;
    --gqrx | gqrx)
        gqrx_load # run usage function
        ;;
    *)
        usage
        exit 1
        ;;
    esac
    shift # remove the current value for `$1` and use the next
done
