#!/bin/bash
sudo apt-get update -y
sudo apt-get install -y expect
export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get -q -y install mysql-server mc curl

SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root:\"
send \"$MYSQL_ROOT_PASSWORD\r\"
expect \"Would you like to setup VALIDATE PASSWORD plugin?\"
send \"n\r\"
expect \"Change the password for root ?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"y\r\"
expect \"Disallow root login remotely?\"
send \"y\r\"
expect \"Remove test database and access to it?\"
send \"y\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

echo "$SECURE_MYSQL"

mysql -uroot -pmysql -e "CREATE DATABASE IF NOT EXISTS punchclock CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
sudo apt-get install -y nodejs

sudo mkdir /home/pc-admin/punchcard
cd /home/pc-admin/punchcard
sudo npm install express
sudo npm install body-parser
sudo npm install mysql

sudo apt-get purge -y expect

wget https://raw.githubusercontent.com/dirkreitz/PunchCard/master/routes.js

exit 0