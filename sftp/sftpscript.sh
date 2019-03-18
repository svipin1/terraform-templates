#!/bin/bash

mountpoint=${mountpoint}
mkdir -p $mountpoint

share_name=${share_name}
username=${share_username}
password=${share_password}

echo "$share_name /sftp cifs vers=3.0,username=$username,password=$password,dir_mode=0777,file_mode=0777" >> /etc/fstab

mount -a