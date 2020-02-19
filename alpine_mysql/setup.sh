#!/usr/bin/env sh

apk --update --no-cache add mysql mysql-client
mysql_install_db --user=mysql --datadir='/var/lib/mysql'

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
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '$DB_ROOT_PASS' WITH GRANT OPTION;

# MYSQL APP USER
CREATE USER '$DB_APP_USER'@'%' IDENTIFIED BY '$DB_APP_PASS';
GRANT ALL PRIVILEGES ON \`$DB_NAME\`.* TO '$DB_APP_USER'@'%' IDENTIFIED BY '$DB_APP_PASS' WITH GRANT OPTION;

# MYSQL APP DATABASE WILL BE CREATED BY YOUR APP/FRAMEWORK

EOF

/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 < $tfile

rm -f $tfile
chown -R mysql:mysql /var/lib/mysql
