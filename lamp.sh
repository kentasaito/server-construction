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
apt install -y php7.0-mbstring

# composer
apt install -y zip
#apt install -y composer
php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
php composer-setup.php
php -r "unlink('composer-setup.php');"
mv composer.phar /usr/local/bin/composer

# Apacheの再起動
a2enmod auth_digest
a2enmod ssl
a2enmod rewrite
service apache2 restart
