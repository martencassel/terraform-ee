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
MANAGER_IP=$3
MANAGER_PUBLIC_DNS=$4
 
echo "Docker Swarm Join: $INSTANCE_ID $PRIVATE_IP $MANAGER_IP $MANAGER_PUBLIC_DNS"
echo "Get worker token..."

AUTH_TOKEN=$(curl -k -X POST "https://$MANAGER_PUBLIC_DNS/auth/login" -H  "accept: application/json" -H  "content-type: application/json" -d "$(get_credentials)"|jq -r ".auth_token");
WORKER_TOKEN=$(curl -k -X GET "https://$MANAGER_PUBLIC_DNS/swarm" -H  "accept: application/json" -H "Authorization: Bearer $AUTH_TOKEN"|jq -r ".JoinTokens.Worker");

echo "Join token: $WORKER_TOKEN";
echo "Joining swarm as worker..."

sudo -E docker swarm join --token $WORKER_TOKEN $MANAGER_IP:2377;


