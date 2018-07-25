
This project will provision a Docker EE environment on AWS, and lets you choose
what versions of components you want, both Engine Version and OS versions plus
the number of different roles like Workers, Managers or DTR.

This project uses only terraform to generate the required scripts to automate the
installation.  
 
```

1. Install terraform
2. Create a folder named files in the project directory.
2. Edit secret.tfvars as the example file, to set AWS credentials.
2. Run terraform init
3. Edit the variables in install.py
4. Run terraform apply with python install.py

```

# Example

The idea is that using a set of variables you can define your desired
Docker EE environment. This is done using terraform only solution 
that generates a set of bash and powershell scripts and run them to setup all machines.

The secret.tfvars define your personal credentials for AWS
and the URl to your Docker EE repository you get from store.docker.com, EE account details, VM credentials.

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
