#!/bin/bash

export OS_VERSION=$1;
export EE_VERSION=$2;
export UCP_VERSION=$3;
export DTR_VERSION=$4;
export MANAGER_COUNT=$5;
export LINUX_WORKER_COUNT=$6;
export WINDOWS_WORKER_COUNT=$7;

echo "OS_VERSION: $OS_VERSION";
echo "EE_VERSION: $EE_VERSION";
echo "UCP_VERSION: $UCP_VERSION";
echo "DTR_VERSION: $DTR_VERSION";
echo "MANAGER_COUNT: $MANAGER_COUNT";
echo "LINUX_WORKER_COUNT: $LINUX_WORKER_COUNT";
echo "WINDOWS_WORKER_COUNT: $WINDOWS_WORKER_COUNT";
 
terraform init;

terraform plan -var-file="secret.tfvars"  \
    -var "os_version=$OS_VERSION" -var "ee_version=$EE_VERSION" \
    -var "ucp_version=$UCP_VERSION" -var "dtr_version=$DTR_VERSION" \
    -var "manager_count=$MANAGER_COUNT" \
    -var "linux_worker_count=$LINUX_WORKER_ACOUNT" \
    -var "windows_worker_count=$WINDOWS_WORKER_COUNT";

terraform destroy -var-file="secret.tfvars"  -auto-approve \
    -var "os_version=$OS_VERSION" -var "ee_version=$EE_VERSION" \
    -var "ucp_version=$UCP_VERSION" -var "dtr_version=$DTR_VERSION" \
    -var "manager_count=$MANAGER_COUNT" \
    -var "linux_worker_count=$LINUX_WORKER_ACOUNT" \
    -var "windows_worker_count=$WINDOWS_WORKER_COUNT";


terraform apply -var-file="secret.tfvars"  -auto-approve \
    -var "os_version=$OS_VERSION" -var "ee_version=$EE_VERSION" \
    -var "ucp_version=$UCP_VERSION" -var "dtr_version=$DTR_VERSION" \
    -var "manager_count=$MANAGER_COUNT" \
    -var "linux_worker_count=$LINUX_WORKER_ACOUNT" \
    -var "windows_worker_count=$WINDOWS_WORKER_COUNT";

