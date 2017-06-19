#!/bin/sh

# DigitalOceanでDropletを作成
# Ubuntu 16.04.2 x64
# $5/mo
# Singapore 1
# Monitoring
# Kenta Saito
# sagittar.org

# タイムゾーンを東京へ
timedatectl set-timezone Asia/Tokyo

# ヒストリ操作の拡張
echo '"\e[A": history-search-backward' >> ~/.inputrc
echo '"\e[B": history-search-forward' >> ~/.inputrc

# 標準エディタをvimへ
update-alternatives --set editor /usr/bin/vim.basic

# 自動アップデート時にメール通知
# 16.04を放置して調べる
sed -i 's#//Unattended-Upgrade::Mail "root";#Unattended-Upgrade::Mail "root";#' /etc/apt/apt.conf.d/50unattended-upgrades

# スワップ
mkdir /var/swap
dd if=/dev/zero of=/var/swap/swap0 bs=2M count=2048
chmod 600 /var/swap/swap0
mkswap /var/swap/swap0
swapon /var/swap/swap0
vi /etc/fstab
# /var/swap/swap0 swap swap defaults 0 0
cat /proc/swaps

# AT
apt -y install at
