#!/bin/bash

# usage
usage="swapx (on|off)"

if [[ $1 == 'on' ]]
then
    # create and activate swapfile
    dd if=/dev/zero of=/swapfile count=4096 bs=1MiB status=progress
    chmod 600 /swapfile
    mkswap /swapfile
    swapon -d /swapfile
    # set swappiness to a lower value (default is 60)
    sysctl vm.swappiness=10
elif [[ $1 == 'off' ]]
then
    # destroy swapfile
    swapoff -v /swapfile
    # overwrite the file with random data before deleting the pointer
    dd if=/dev/urandom bs=1 count=32 | base64 | dd of=/swapfile
    rm /swapfile
else
    echo $usage
fi
