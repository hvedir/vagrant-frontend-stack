#!/bin/bash

cd /tmp

wget https://get.rvm.io -O ruby-installer
chmod +x ruby-installer
sudo ./ruby-installer --ruby
source /etc/profile.d/rvm.sh

cd ~/