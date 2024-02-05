#!/bin/sh

#Author:tman904 aka Tyler K Monroe
#Purpose:Downloads an OpenBSD install iso and setups qemu VM with one 8GB virtual disk ,1024Megabytes of RAM and one vNIC using tun0 on the Linux host OS
#Version:0.0.1
#Date:2/5/2024 00:13

dlfile="install$vn1$vn2.iso"
qemu_img_file="obsd.img"
osver="7.4"
arch="amd64"
#remove dot from osver variable.
vn1=`echo $osver |cut -d '.' -f1` 
vn2=`echo $osver |cut -d '.' -f2`

sudo apt-get install qemu qemu-system
sudo apt-get install uml-utilities
sudo ifconfig tun0 0.0.0.0
sudo tunctl -d tun0
sleep 2

sudo tunctl -t tun0

sudo ifconfig tun0 192.168.10.2

echo "pulling down OpenBSD $osver $arch"
wget https://cdn.openbsd.org/pub/OpenBSD/$osver/$arch/install$vn1$vn2.iso
sudo qemu-img create -f qcow2 obsd.img 8G

sudo qemu-system-x86_64 -m 1024M -cdrom ./install$vn1$vn2.iso -netdev tap,id=net0,ifname=tun0,script=no,downscript=no -device e1000,netdev=net0 obsd.img

#clean up host system

sudo ifconfig tun0 down
sudo tunctl -d tun0
sudo rm ./$qemu_img_file
sudo rm ./install$vn1$vn2.iso
