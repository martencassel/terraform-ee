#!/bin/bash -e

get_credentials() {
  cat << EOF
{
  "username": "${admin_username}",
  "password": "${admin_password}"
}
EOF
}

# terraform variables: ucp_version, admin_username, admin_password

# resource arguments: 
INSTANCE_ID=$1
PRIVATE_IP=$2
PRIVATE_DNS=$3
MANAGER_IP=$4
MANAGER_PUBLIC_DNS=$5
  

echo "Docker Swarm Join: $INSTANCE_ID $PRIVATE_IP $MANAGER_IP $MANAGER_PUBLIC_DNS"
echo "Get worker token..."

AUTH_TOKEN=$(curl -k -X POST "https://$MANAGER_PUBLIC_DNS/auth/login" -H  "accept: application/json" -H  "content-type: application/json" -d "$(get_credentials)"|jq -r ".auth_token");
WORKER_TOKEN=$(curl -k -X GET "https://$MANAGER_PUBLIC_DNS/swarm" -H  "accept: application/json" -H "Authorization: Bearer $AUTH_TOKEN"|jq -r ".JoinTokens.Worker");

echo "Join token: $WORKER_TOKEN";
echo "Joining swarm as worker..."

sudo -E docker swarm join --token $WORKER_TOKEN $MANAGER_IP:2377;

echo "Sleeping for a while..."
sleep 40

if [ "$INSTANCE_ID" == "0" ]; then

  echo "docker dtr install: $INSTANCE_ID $PRIVATE_IP $MANAGER_IP $MANAGER_PUBLIC_DNS"

  REPLICA_ID="100000000000";

  sudo -E docker run -it --rm docker/dtr:${dtr_version} install \
    --debug \
    --ucp-insecure-tls \
    --replica-id $REPLICA_ID \
    --ucp-node $(hostname) \
    --ucp-url https://$MANAGER_PUBLIC_DNS \
    --ucp-username  ${admin_username} \
    --ucp-password ${admin_password}

else
  echo "Docker DTR Join: $INSTANCE_ID $PRIVATE_IP $MANAGER_IP $MANAGER_PUBLIC_DNS"

  export NEXT_REPLICA_ID="10000000000$INSTANCE_ID";
  echo "NEXT_REPLICA_ID: $NEXT_REPLICA_ID";
  
  sudo -E docker run -it --rm docker/dtr:${dtr_version} join \
    --debug \
    --replica-id $NEXT_REPLICA_ID \
    --existing-replica-id "100000000000" \
    --ucp-insecure-tls \
    --ucp-node $(hostname) \
    --ucp-url https://$MANAGER_PUBLIC_DNS \
    --ucp-username  ${admin_username} \
    --ucp-password ${admin_password};
fi


