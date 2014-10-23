#!/usr/bin/env bash

if [ -e "/etc/vagrant-provisioned" ];
then
    echo "Vagrant provisioning already completed. Skipping..."
    exit 0
else
    echo "Starting Vagrant provisioning process..."
fi

# Change the hostname so we can easily identify what environment we're on:
echo "nodejs-vagrant" > /etc/hostname
# Update /etc/hosts to match new hostname to avoid "Unable to resolve hostname" issue:
echo "127.0.0.1 nodejs-vagrant" >> /etc/hosts
# Use hostname command so that the new hostname takes effect immediately without a restart:
hostname nodejs-vagrant

# Install core components
/vagrant/provision/sh/core.sh

# Install Node.js
/vagrant/provision/sh/nodejs.sh
/vagrant/provision/sh/nodejs-modules.sh

# Install Ruby gems
/vagrant/provision/sh/ruby.sh
/vagrant/provision/sh/ruby-gems.sh

# Install MongoDB
/vagrant/provision/sh/mongodb.sh

# GitHub repositories:
/vagrant/provision/sh/github.sh

# Heroku toolbelt (NOTE: after Travis-CI due to Ruby removal/reinstall):
/vagrant/provision/sh/heroku.sh

# Dotfiles
/vagrant/provision/sh/dotfiles.sh

touch /etc/vagrant-provisioned

# Init
/vagrant/provision/sh/init.sh

echo "--------------------------------------------------"
echo "Your vagrant instance is running at: 192.168.33.10"
