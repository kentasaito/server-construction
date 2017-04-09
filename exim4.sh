#!/bin/sh

ROOTMAIL=kenta.saito@sagittar.org

# Exim4
apt install -y exim4
sed -i "s/dc_eximconfig_configtype='local'/dc_eximconfig_configtype='internet'/" /etc/exim4/update-exim4.conf.conf
update-exim4.conf

# 送信テスト
echo "root: $ROOTMAIL" >> /etc/aliases
echo 'Exim4の送信テスト' | mail -s 'Exim4の送信テスト' root
