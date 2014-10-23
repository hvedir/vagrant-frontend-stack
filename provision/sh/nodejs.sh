#!/bin/bash

# Modified from https://github.com/joyent/node/wiki/Installing-Node.js-via-package-manager
sudo apt-get update
sudo apt-get install -y python-software-properties python g++ make
sudo add-apt-repository -y ppa:chris-lea/node.js
sudo apt-get update
sudo apt-get install -y nodejs
