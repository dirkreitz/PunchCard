#!/bin/bash
apt-get update -y
##apt-get install -y expect
export DEBIAN_FRONTEND=noninteractive
sudo -E apt-get -q -y install mc
