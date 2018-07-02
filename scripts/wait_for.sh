admin_username=admin
admin_password=P@ssw0rd

get_credentials() {
  cat << EOF
{
  "username": "$admin_username",
  "password": "$admin_password"
}
EOF
}

MANAGER_PUBLIC_DNS=ec2-52-59-188-125.eu-central-1.compute.amazonaws.com;

AUTH_TOKEN=$(curl -k -X POST "https://$MANAGER_PUBLIC_DNS/auth/login" -H  "accept: application/json" -H  "content-type: application/json" -d "$(get_credentials)"|jq -r ".auth_token");
curl -k -X GET "https://$MANAGER_PUBLIC_DNS/swarm" -H  "accept: application/json" -H "Authorization: Bearer $AUTH_TOKEN"|jq -r ".JoinTokens.Manager"
