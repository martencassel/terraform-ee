
TF_VAR_os_version="RHEL-7.5";  
TF_VAR_ee_version="17.06.2-ee-14"; 
TF_VAR_ucp_version="3.0.2"; 
TF_VAR_dtr_version="2.5.3"; 
TF_VAR_manager_count=1; 
TF_VAR_dtr_count=0; 
TF_VAR_linux_worker_count=3; 
TF_VAR_windows_worker_count=0;

terraform plan -var-file="secret.tfvars";

terraform apply -var-file="secret.tfvars" -auto-approve;

