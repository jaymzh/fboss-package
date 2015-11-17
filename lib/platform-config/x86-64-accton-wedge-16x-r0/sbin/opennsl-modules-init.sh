#!/bin/bash

if [ -e /proc/linux-user-bde ]; then
    echo "Removing installed linux-user-bde kernel module"
    rmmod linux-user-bde
fi

if [ -e /proc/linux-kernel-bde ]; then
    echo "Removing installed linux-kernel-bde kernel module"
    rmmod linux-kernel-bde
fi

echo "Inserting OpenNSL kernel modules"
insmod /lib/modules/`uname -r`/linux-kernel-bde.ko maxpayload=128 dmasize=64M
insmod /lib/modules/`uname -r`/linux-user-bde.ko

echo "Adding kernel module dev files"
if ! [ -e /dev/linux-kernel-bde ]; then
    echo "Adding /dev/linux-kernel-bde"
    mknod /dev/linux-kernel-bde c 127 0
else
    echo "/dev/linux-kernel-bde already exists"
fi

if ! [ -e /dev/linux-user-bde ]; then
    echo "Adding /dev/linux-kernel-bde"
    mknod /dev/linux-user-bde c 126 0
else
    echo "/dev/linux-user-bde already exists"
fi

/usr/local/bin/wedge_agent -config /etc/fboss/ocp-demo.json &
echo "wedge_agent started. Wait about 30-60s for initialization to complete"
exit 0
