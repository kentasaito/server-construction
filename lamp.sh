#!/bin/sh

MYSQLPW=

# Apache2
apt install -y apache2

# MySQL5.7
echo "mysql-server mysql-server/root_password password $MYSQLPW" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $MYSQLPW" | sudo debconf-set-selections
apt-get -y install mysql-server
cp -a /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf.orig
sed -i 's/\[mysqld\]/[mysqld]\ncharacter-set-server = utf8/' /etc/mysql/mysql.conf.d/mysqld.cnf
service mysql restart
echo "show variables like 'chara%';" | mysql -p$MYSQLPW

# PHP7.0
apt install -y libapache2-mod-php7.0
apt install -y php7.0-mysql

# Apacheの再起動
a2enmod ssl
a2enmod rewrite
service apache2 restart
