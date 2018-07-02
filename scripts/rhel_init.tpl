#!/bin/sh

USERNAME=${rhsm_username}
PASSWORD=${rhsm_password}

sudo subscription-manager register --username ${rhsm_username} --password ${rhsm_password};
sudo subscription-manager attach;

#sudo yum -y update;
sudo yum -y install wget;
sudo wget -O jq https://github.com/stedolan/jq/releases/download/jq-1.5/jq-linux64;
sudo chmod +x ./jq;
sudo cp jq /usr/bin;

