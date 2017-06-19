#!/bin/sh

. ./variables.sh

apt install -y php7.0-zip
apt install -y libreoffice-calc
service apache2 restart
fc-cache
