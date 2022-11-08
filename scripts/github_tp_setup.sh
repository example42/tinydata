#!/usr/bin/env bash
PATH=/opt/puppetlabs/puppet/bin:/usr/local/sbin:$PATH
wget -O - https://bit.ly/installpuppet | sudo bash

# Let's use tinydaya from the PR
sudo mkdir -p /etc/puppetlabs/code/modules/tinydata/
sudo ln -s /home/runner/work/tinydata/tinydata/data /etc/puppetlabs/code/modules/tinydata/data

echo "### Installing Tiny Puppet"
sudo puppet module install example42-tp --ignore-dependencies
sudo puppet module install puppetlabs-stdlib --ignore-dependencies
sudo puppet tp setup


exit 0