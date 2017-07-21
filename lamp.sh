#!/bin/sh

. ./variables.sh

# Apache2
apt install -y apache2
chsh -s /bin/bash www-data
cp -r /root/.ssh /var/www
chown -R www-data:www-data /var/www
cp -a /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.orig
cat << EOS | patch -u /etc/apache2/sites-available/default-ssl.conf
--- default-ssl.conf.orig	2017-06-20 20:08:17.163426534 +0900
+++ default-ssl.conf	2017-06-20 20:15:50.172346009 +0900
@@ -1,5 +1,16 @@
 <IfModule mod_ssl.c>
 	<VirtualHost _default_:443>
+		<Directory "/var/www/html">
+			Options Indexes FollowSymLinks MultiViews
+			AllowOverride All
+			Order allow,deny
+			allow from all
+			AuthType Digest
+			AuthName "control"
+			AuthDigestDomain /
+			AuthUserFile /var/www/.htdigest
+			Require valid-user
+		</Directory>
 		ServerAdmin webmaster@localhost
 
 		DocumentRoot /var/www/html
EOS
a2ensite default-ssl.conf
cp -a /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/000-default.conf.orig
cat << EOS | patch -u /etc/apache2/sites-available/000-default.conf
--- 000-default.conf.orig	2016-03-19 18:48:35.000000000 +0900
+++ 000-default.conf	2017-06-20 20:21:53.070988838 +0900
@@ -26,6 +26,17 @@
 	# following line enables the CGI configuration for this host only
 	# after it has been globally disabled with "a2disconf".
 	#Include conf-available/serve-cgi-bin.conf
+	<Directory "/var/www/html">
+		Options Indexes FollowSymLinks MultiViews
+		AllowOverride All
+		Order allow,deny
+		allow from all
+		AuthType Digest
+		AuthName "control"
+		AuthDigestDomain /
+		AuthUserFile /var/www/.htdigest
+		Require valid-user
+	</Directory>
 </VirtualHost>
 
 # vim: syntax=apache ts=4 sw=4 sts=4 sr noet
EOS
touch /var/www/.htdigest
chown www-data:www-data /var/www/.htdigest

# MySQL5.7
apt install -y mysql-server
cp -a /etc/mysql/mysql.conf.d/mysqld.cnf /etc/mysql/mysql.conf.d/mysqld.cnf.orig
sed -i 's/\[mysqld\]/[mysqld]\nskip-grant-tables\ncharacter-set-server = utf8/' /etc/mysql/mysql.conf.d/mysqld.cnf
service mysql restart

# PHP7.0
apt install -y libapache2-mod-php7.0
apt install -y php7.0-mysql
apt install -y php7.0-xml
apt install -y php7.0-mbstring

# composer
apt install -y zip
apt install -y composer
#php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
#php -r "if (hash_file('SHA384', 'composer-setup.php') === '669656bab3166a7aff8a7506b8cb2d1c292f042046c5a994c43155c0be6190fa0355160742ab2e1c88d40d5be660b410') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
#php composer-setup.php
#php -r "unlink('composer-setup.php');"
#mv composer.phar /usr/local/bin/composer

# Apacheの再起動
a2enmod auth_digest
a2enmod ssl
a2enmod rewrite
service apache2 restart
