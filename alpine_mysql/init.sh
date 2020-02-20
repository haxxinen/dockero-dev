#!/usr/bin/env sh

[ -e "/var/lib/mysql/$DB_NAME" ] && echo 'MySQL already initiated!' && exit

[[ \
	"$DB_NAME" = "" || \
	"$DB_ROOT_PASS" = "" || \
	"$DB_APP_USER" = "" || \
	"$DB_APP_PASS" = "" \
]] && echo 'Credentials empty/not exported.' && exit

mysql_install_db --user=mysql --datadir='/var/lib/mysql'
tfile=`mktemp`
cat << EOF > $tfile

# MYSQL ROOT PASSWORD
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$DB_ROOT_PASS' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;

# MYSQL APP USER
CREATE USER '$DB_APP_USER'@'%' IDENTIFIED BY '$DB_APP_PASS';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_APP_USER'@'%' IDENTIFIED BY '$DB_APP_PASS' WITH GRANT OPTION;

# MYSQL APP DATABASE
DROP DATABASE IF EXISTS \`$DB_NAME\`;
CREATE DATABASE \`$DB_NAME\` CHARACTER SET utf8 COLLATE utf8_general_ci;

# DROP TEST DATABASE
DROP DATABASE IF EXISTS \`test\`;

EOF

/usr/bin/mysqld --user=root --bootstrap --verbose=0 < $tfile

rm -f $tfile
chown -R mysql:mysql /var/lib/mysql

unset DB_NAME
unset DB_ROOT_PASS
unset DB_APP_USER
unset DB_APP_PASS
