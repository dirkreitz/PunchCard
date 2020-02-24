#!/bin/bash
sudo -E apt-get -q -y update && sudo -E apt-get -q -y upgrade
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
mysql -uroot -pmysql -e "USE punchclock;CREATE TABLE IF NOT EXISTS devicetable (ID int(16) NOT NULL, device varchar(128) NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;";
mysql -uroot -pmysql -e "USE punchclock;CREATE TABLE IF NOT EXISTS timetable (ID int(16) NOT NULL, name varchar(128) NOT NULL, deviceID int(16) NOT NULL, check_type int(4) NOT NULL, UNIX_TIMESTAMP timestamp NOT NULL DEFAULT current_timestamp(), punch_method varchar(32) NOT NULL) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;";
mysql -uroot -pmysql -e "USE punchclock;ALTER TABLE devicetable ADD PRIMARY KEY (ID), ADD UNIQUE KEY device (device);";
mysql -uroot -pmysql -e "USE punchclock;ALTER TABLE timetable ADD PRIMARY KEY (ID), ADD KEY appID (deviceID);";
mysql -uroot -pmysql -e "USE punchclock;ALTER TABLE devicetable MODIFY ID int(16) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;";
mysql -uroot -pmysql -e "USE punchclock;ALTER TABLE timetable MODIFY ID int(16) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;";
mysql -uroot -pmysql -e "USE punchclock;ALTER TABLE timetable ADD CONSTRAINT fk_appID FOREIGN KEY (deviceID) REFERENCES devicetable (ID), ADD CONSTRAINT fk_name FOREIGN KEY (deviceID) REFERENCES devicetable (ID);COMMIT;";

mysql -uroot -pmysql -e "CREATE USER 'admin'@'localhost' IDENTIFIED BY '$up3r$3cur3';"
mysql -uroot -pmysql -e "GRANT ALL PRIVILEGES ON * . * TO 'admin'@'localhost' WITH GRANT OPTION;"
mysql -uroot -pmysql -e "FLUSH PRIVILEGES;"

echo "bind-address = 0.0.0.0" | sudo tee -a /etc/mysql/mysql.conf.d/mysqld.cnf
sudo systemctl restart mysql

curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
sudo apt-get install -y nodejs

sudo mkdir /home/pc-admin/punchcard
cd /home/pc-admin/punchcard
sudo npm install express
sudo npm install body-parser
sudo npm install mysql

sudo apt-get purge -y expect
sudo apt -y autoremove

wget https://raw.githubusercontent.com/dirkreitz/PunchCard/master/routes.js

exit 0
