#!/bin/sh

MYSQLPW=

echo "show variables like 'chara%';" | mysql -p$MYSQLPW
echo "SELECT User, Host, plugin FROM mysql.user;" | mysql -p$MYSQLPW
