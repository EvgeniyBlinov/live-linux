#!/bin/bash

echo "[Info] Updating apt"
sudo apt-get update -y && \
    sudo env DEBIAN_FRONTEND=noninteractive apt-get upgrade -yqq

echo "[Info] Installing apps"
sudo env DEBIAN_FRONTEND=noninteractive apt-get install -yqq \
    git \
    make \
    mc \
    tmux \
    vim \
    iputils-ping \
    curl \
    htop


echo "[Info] Installing apps"
sudo env DEBIAN_FRONTEND=noninteractive apt-get install -yqq \
    apt-cacher-ng \
    xorriso \
    syslinux-common \
    live-boot \
    live-boot-initramfs-tools \
    live-tools \
    debian-keyring \
    debian-archive-keyring \
    debootstrap


echo "[Info] Apt clean"
sudo apt-get -f install
sudo apt-get clean
