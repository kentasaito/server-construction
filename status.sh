#!/bin/sh

. ./variables.sh

echo "show variables like 'chara%';" | mysql
echo "SELECT User, Host, plugin FROM mysql.user;" | mysql
