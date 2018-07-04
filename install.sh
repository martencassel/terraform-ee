#!/bin/bash

export OS_VERSION=$1;
export EE_VERSION=$2;
export UCP_VERSION=$3;
export DTR_VERSION=$4;

export UCP_COUNT=$5;
export DTR_COUNT=$6;
export LINUX_WORKER_COUNT=$7;
export WINDOWS_WORKER_COUNT=$8;

TF_VAR_os_version=$OS_VERSION; 
TF_VAR_ee_version=$EE_VERSION;
TF_VAR_ucp_version=$UCP_VERSION;
TF_VAR_dtr_version=$DTR_VERSION;
TF_VAR_manager_count=$UCP_COUNT;
TF_VAR_dtr_count=$DTR_COUNT;
TF_VAR_linux_worker_count=$LINUX_WORKER_COUNT;
TF_VAR_windows_worker_count=$WINDOWS_WORKER_COUNT;

# A license file must exists. If empty then it will be ignored when installing.
touch ./files/docker_subscription.lic

echo "OS_VERSION: $OS_VERSION";
echo "EE_VERSION: $EE_VERSION";
echo "UCP_VERSION: $UCP_VERSION";
echo "DTR_VERSION: $DTR_VERSION";

echo "UCP_COUNT: $UCP_COUNT";
echo "DTR_COUNT: $DTR_COUNT";
echo "LINUX_WORKER_COUNT: $LINUX_WORKER_COUNT";
echo "WINDOWS_WORKER_COUNT: $WINDOWS_WORKER_COUNT";
 
terraform init;

terraform plan -var-file="secret.tfvars";

terraform apply -var-file="secret.tfvars" -auto-approve;

