#!/bin/bash
apt-get update -y
##apt-get install -y expect
export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get -q -y install mc curl
curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
sudo apt-get install -y nodejs
sudo mkdir /home/pc-admin/punchcard
cd /home/pc-admin/punchcard
sudo npm install express
sudo npm install body-parser
sudo npm install promise-mysql
sudo npm install bluebird
exit 0