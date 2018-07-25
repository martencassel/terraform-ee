#!/bin/python
from python_terraform import *
 
secret_varfile="./secret.tfvars"

variables = {
    'os_version': "RHEL-7.5",
    'ee_version': "17.06.2-ee-14",
    'ucp_version': "3.0.2",
    'dtr_version': "2.5.3",
    'manager_count': 0,
    'dtr_count': 0,
    'linux_worker_count': 0,
    "windows_os_version": "2016_base",
    'windows_worker_count': 1,
}

tf = Terraform(working_dir='.', 
               variables=variables, 
               var_file=secret_varfile)

kwargs = {"auto-approve": True }
print(tf.destroy())

