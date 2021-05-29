#!/bin/bash

source /opt/Radio-VNC/functions.sh

usage(){
  echo "radiovnc-samba needs arguments\n--start=Start the samba server\n--stop=Stop the samba server\n--help display this message"
  exit
}

if [ $# -eq 0 ]; then
    usage # run usage function
    exit 1
fi

while [ "$1" != "" ]; do
    case $1 in
    --start)
        start_samba=TRUE
        ;;
    --stop)
        stop_samba=TRUE
        ;;
    -h | --help)
        usage # run usage function
        ;;
    *)
        usage
        exit 1
        ;;
    esac
    shift # remove the current value for `$1` and use the next
done

if [ "$start_samba"=TRUE ]; then
  samba_start
fi

if [ "$stop_samba"=TRUE ]; then
  samba_stop
fi
