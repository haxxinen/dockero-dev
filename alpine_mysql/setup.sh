#!/usr/bin/env sh

apk --update --no-cache add mysql mysql-client
mysql_install_db --user=mysql --datadir='/var/lib/mysql' >/dev/null
mkdir -p /run/mysqld

[[ \
	"$DB_NAME" = "" || \
	"$DB_ROOT_PASS" = "" || \
	"$DB_APP_USER" = "" || \
	"$DB_APP_PASS" = "" \
]] && echo 'Credentials empty/not exported.' && exit

tfile=`mktemp`
cat << EOF > $tfile

# MYSQL ROOT PASSWORD
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '$DB_ROOT_PASS' WITH GRANT OPTION;

# MYSQL APP USER
CREATE USER '$DB_APP_USER'@'%' IDENTIFIED BY '$DB_APP_PASS';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_APP_USER'@'%' IDENTIFIED BY '$DB_APP_PASS' WITH GRANT OPTION;

# # MYSQL APP DATABASE
DROP DATABASE IF EXISTS \`$DB_NAME\`;
CREATE DATABASE \`$DB_NAME\` CHARACTER SET utf8 COLLATE utf8_general_ci;
DROP DATABASE IF EXISTS \`test\`;

EOF

/usr/bin/mysqld --user=root --bootstrap --verbose=0 < $tfile

rm -f $tfile
