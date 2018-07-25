# Background

The idea is that using a set of variables you can define your desired
Docker EE environment. This is done using terraform only solution 
that generates a set of bash and powershell scripts and run them to setup all machines.

You define your AWS credentials, Docker EE subscription file (optional) and other information in the secret.tfvars file.

# Getting Started
 
```

1. Install terraform
2. Create a folder named files in the project directory.
2. Edit secret.tfvars as the example file, to set AWS credentials.
2. Run terraform init
3. Edit the variables in install.py
4. Run terraform apply with python install.py

```

# Example

The example below will provision 4 node cluster consisting of 1 Manager 3 Worker nodes.

The manager will be hosted on a RHEL 7.5 machine with the Docker EE Engine 17.06.2-ee-14 release.
The worker nodes will be hosted on Windows Server 2016 with the same EE engine version as the linux one.

```
variables = {
    'os_version': "RHEL-7.5",
    'ee_version': "17.06.2-ee-14",
    'ucp_version': "3.0.2",
    'dtr_version': "2.5.3",
    'manager_count': 1,
    'dtr_count': 0,
    'linux_worker_count': 0,
    "windows_os_version": "2016_base",
    'windows_worker_count': 3,
}
```
