* Create a secret.tfvars file and define your 
  secret variables like below:
  
```
region = "eu-central-1"
access_key = "my-acceess-key"
secret_key = "aws-secret-key"
rhsm_username = "email"
rhsm_password = "password"
docker_ee_url = "https://storebits.docker.com/ee/rhel/sub-<subscription-id>"
admin_username = "<a username>"
admin_password = "<a password>"
```

* This project can upload a Docker license to your UCP controller.
  Put your docker subscription licensefile with this path:  

  ./files/docker_subscription.lic

# See: https://success.docker.com/article/compatibility-matrix
#      https://docs.docker.com/ee/ucp/release-notes/
#      https://docs.docker.com/ee/dtr/release-notes/
