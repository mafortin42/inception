#! /bin/bash

echo "START OF INIT_DB SCRIPT"
SQL_DATA_DIR="/var/lib/mysql"
DB_NAME="wordpress_db"
DB_USER="mafortin"
DB_PASSWORD='pass'
DB_ROOT_PASSWORD='root'
if [ ! -d "./run_mysqld.tmp" ]; then
	echo "Creating mysql daemon directory + adding rights"
	mkdir /run/mysqld
	chown -R mysql:mysql /run/mysqld
	touch ./run_mysqld.tmp
fi
if [ ! -d "./var_mysql.tmp" ]; then
	echo "INSTALLING DB"
	chown -R mysql:mysql /var/lib/mysql
	mysql_install_db --user=mysql  --basedir=/usr --datadir=$SQL_DATA_DIR
	service mysql start & sleep 5
	mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';"
	echo "ROOT PASSWORD SET"
	mysql -u root -p$DB_ROOT_PASSWORD -e "CREATE DATABASE IF NOT EXISTS $DB_NAME CHARACTER SET utf8 COLLATE utf8_general_ci;"
	echo "DB CREATED"
	mysql -u root -p$DB_ROOT_PASSWORD -e "CREATE USER '${DB_USER}'@'localhost' IDENTIFIED BY '${DB_PASSWORD}';"
	echo "USER CREATED"
	mysql -u root -p$DB_ROOT_PASSWORD -e "GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO ${DB_USER}@'%' IDENTIFIED BY '${DB_PASSWORD}';"
	echo "PRIVILEGES GRANTED"
	mysql -u root -p$DB_ROOT_PASSWORD -e "FLUSH PRIVILEGES;"
	touch ./var_mysql.tmp
	killall mysqld
fi
echo "MARIADB SETUP COMPLETED"
echo "MARIADB SERVER LISTENING ON 3306"
exec $@