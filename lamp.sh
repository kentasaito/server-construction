#!/bin/sh

. ./variables.sh

# Apache2
apt install -y apache2
chsh -s /bin/bash www-data

# MySQL5.7
echo "mysql-server mysql-server/root_password password $MYSQLPW" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $MYSQLPW" | sudo debconf-set-selections
apt install -y mysql-server
cp -a /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf.orig
sed -i 's/\[mysqld\]/[mysqld]\ncharacter-set-server = utf8/' /etc/mysql/mysql.conf.d/mysqld.cnf
echo 'UPDATE `mysql`.`user` SET `plugin`="mysql_native_password" WHERE `User`="root"; FLUSH PRIVILEGES;' | mysql -p$MYSQLPW
service mysql restart
echo 'SET password FOR root@localhost=password("");' | mysql -p$MYSQLPW

# PHP7.0
apt install -y libapache2-mod-php7.0
apt install -y php7.0-mysql
apt install -y php7.0-xml

# Apacheの再起動
a2enmod auth_digest
a2enmod ssl
a2enmod rewrite
service apache2 restart
