#!/usr/bin/env bash
PATH=/opt/puppetlabs/puppet/bin:/usr/local/sbin:$PATH
wget -O - https://bit.ly/installpuppet | sudo bash

echo "### Installing Tiny Puppet"
sudo puppet module install example42-tp
sudo puppet tp setup
