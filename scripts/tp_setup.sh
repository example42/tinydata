#!/usr/bin/env bash
PATH=/opt/puppetlabs/puppet/bin:/usr/local/sbin:$PATH
wget -O - https://bit.ly/installpuppet | sudo bash
puppet module install example42-tp
puppet tp setup