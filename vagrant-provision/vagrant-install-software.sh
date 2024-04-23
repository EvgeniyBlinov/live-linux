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
    ncdu \
    htop


echo "[Info] Installing apps"
sudo env DEBIAN_FRONTEND=noninteractive apt-get install -yqq \
    apt-cacher-ng                \
    xorriso                      \
    syslinux-common              \
    live-boot                    \
    live-boot-initramfs-tools    \
    live-tools                   \
    debian-keyring               \
    debian-archive-keyring       \
    debian-ports-archive-keyring \
    debian-security-support      \
    ntp                          \
    systemd-container            \
    debootstrap


echo "[Info] Apt clean"
sudo apt-get -f install
sudo apt-get clean

if ! test -f /home/vagrant/.config/mc/ini ; then
    mkdir -p /home/vagrant/.config/mc
    echo -e "[Panels]\nnavigate_with_arrows=true" >> /home/vagrant/.config/mc/ini
    chown vagrant:vagrant -R /home/vagrant
fi

if ! test -f /root/.config/mc/ini ; then
    mkdir -p /root/.config/mc
    echo -e "[Panels]\nnavigate_with_arrows=true" >> /root/.config/mc/ini
fi

echo "[Info] Installing live-build dependencies"
sudo env DEBIAN_FRONTEND=noninteractive apt-get install -yqq \
    devscripts

systemctl enable ntp
systemctl start ntp
