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

IS_MANAGER=false
HAVE_DOCKER_SUBSCRIPTION=false

if [ "$INSTANCE_ID" == "0" ]; then
  IS_MANAGER=true
fi

if [[ -s /tmp/docker_subscription.lic ]]; then 
  HAVE_DOCKER_SUBSCRIPTION=true
fi

if [ "$IS_MANAGER" == true ]; then

  echo "docker swarm init: $INSTANCE_ID $PRIVATE_IP $MANAGER_IP $MANAGER_PUBLIC_DNS"

  sudo -E docker container run --rm -it --name ucp \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /tmp/docker_subscription.lic:/config/docker_subscription.lic \
    docker/ucp:${ucp_version} install \
    --host-address $PRIVATE_IP \
    --admin-username ${admin_username} \
    --admin-password ${admin_password} \
    --san $MANAGER_PUBLIC_DNS;

else

  echo "Wait for manager..."
  sleep 50

  echo "Docker Swarm Join: $INSTANCE_ID $PRIVATE_IP $MANAGER_IP $MANAGER_PUBLIC_DNS"

  echo "Get manager token..."
  AUTH_TOKEN=$(curl -k -X POST "https://$MANAGER_PUBLIC_DNS/auth/login" -H  "accept: application/json" -H  "content-type: application/json" -d "$(get_credentials)"|jq -r ".auth_token");
  curl -k -X GET "https://$MANAGER_PUBLIC_DNS/swarm" -H  "accept: application/json" -H "Authorization: Bearer $AUTH_TOKEN"|jq -r ".JoinTokens.Manager"
  
  MANAGER_TOKEN=$(curl -k -X GET "https://$MANAGER_PUBLIC_DNS/swarm" -H  "accept: application/json" -H "Authorization: Bearer $AUTH_TOKEN"|jq -r ".JoinTokens.Manager");

  echo "Join token: $MANAGER_TOKEN";
  
  echo "Joining swarm as manager..."
  sudo -E docker swarm join --token $MANAGER_TOKEN $MANAGER_IP:2377;

fi


