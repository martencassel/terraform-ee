# Download client bundle (username,password,url)
function getbundle() {
    USERNAME=$1;
    PASSWORD=$2;
    UCP_URL=$3;

    AUTHTOKEN=$(curl -sk -d '{"username":"$USERNAME","password":"$PASSWORD"}' https://$UCP_URL/auth/login | jq -r .auth_token)
    curl -k -H "Authorization: Bearer $AUTHTOKEN" https://$UCP_URL/api/clientbundle -o /tmp/bundle.zip

    mkdir -p ~/.ucp_bundle;
}
# Load bundle ($PWD/.ucp)