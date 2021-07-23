#!/bin/bash

samba_start() {
    systemctl enable smbd
    systemctl start smbd
}

samba_stop() {
    systemctl disable smbd
    systemctl stop smbd
}

samba_config() {
    echo "
  [Radio-VNC]
  path = /
  writeable=Yes
  create mask=0777
  directory mask=0777
  public=no" >>/etc/samba/smb.conf
}