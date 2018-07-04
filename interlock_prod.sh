#!/bin/sh
 
OS_VERSION="RHEL-7.5";  
EE_VERSION="17.06.2-ee-14"; 
UCP_VERSION="3.0.2"; 
DTR_VERSION="2.5.3"; 

UCP_COUNT=1; DTR_COUNT=0; 
LINUX_WORKER_COUNT=3; 
WINDOWS_WORKER_COUNT=0;

./install.sh $OS_VERSION $EE_VERSION $UCP_VERSION $DTR_VERSION \
    $UCP_COUNT \
    $DTR_COUNT \
    $LINUX_WORKER_COUNT \
    $WINDOWS_WORKER_COUNT;

# https://docs.docker.com/ee/ucp/interlock/deploy/production/