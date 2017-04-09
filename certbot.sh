#!/bin/sh

# Certbot
add-apt-repository -y ppa:certbot/certbot
apt update
apt install -y python-certbot-apache 
certbot --apache
crontab -e
