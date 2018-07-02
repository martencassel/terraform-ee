#!/bin/sh

# arguments
PACKAGE_DIRPATH=${package_path}

# install docker
export DOCKERURL=${docker_ee_url};
export PACKAGE_URL=$DOCKERURL/$PACKAGE_DIRPATH;

sudo yum-config-manager --enable rhel-7-server-extras-rpms;
wget $PACKAGE_URL -O /tmp/docker_ee.rpm;

sudo yum -y install /tmp/docker_ee.rpm;
sudo systemctl enable --now docker;

