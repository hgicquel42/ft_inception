#!/bin/bash

sed -ie 's/bind-address/#bind-address/g' /etc/mysql/mariadb.conf.d/50-server.cnf
sed -ie 's/#port/port/g' /etc/mysql/mariadb.conf.d/50-server.cnf

if [ ! -d /var/lib/mysql/$MYSQL_WP_NAME ]
then
service mysql start

mysql --user=root --password=$MYSQL_ROOT_PASSWORD <<EOF
CREATE DATABASE IF NOT EXISTS $MYSQL_WP_NAME;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';
GRANT ALL PRIVILEGES ON $MYSQL_WP_NAME.* TO '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD' WITH GRANT OPTION;
ALTER USER 'root'@'localhost' IDENTIFIED BY '123';
FLUSH PRIVILEGES;
EOF

service mysql stop
fi

exec "$@"
