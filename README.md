
# Background

You define your desired Docker EE cluster environment topology (nr of managers, workers) along 
with the desired software versions of different components (Host OS, Engine Release, UCP Release, DTR Release),
using a set of variables. Everything is tested on a mac, with python and terraform.

Here is an example:


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

```
python install.py
```

This matrix describe the possible configuration options:


| OS Distribution        | Enterprise Engine           | UCP  | DTR |
| ------------- |:-------------:| -----:| -----:|
| RHEL 7.3      | 17.06.1<sup>1</sup> 17.06.2<sup>2</sup>  | Any available | Any available |
| RHEL 7.4      | 17.06.1<sup>1</sup> 17.06.2<sup>2</sup>      |   Any available | Any available |
| RHEL 7.5 | 17.06.1<sup>1</sup> 17.06.2<sup>2</sup>      |    Any available | Any available |
| Windows Server 2016 | 17.06.1<sup>1</sup> 17.06.2<sup>2</sup>     |    Any available | Any available |
| Windows Server 1709 | 17.06.1<sup>1</sup> 17.06.2<sup>2</sup>      |    Any available | Any available |
| Windows Server 1803 | 17.06.1<sup>1</sup> 17.06.2<sup>2</sup>      |    Any available | Any available |

The following versions are currently available from a Docker EE package repository:
<sup>1</sup> 17.06.1-ee-1, 17.06.1-ee-2
<sup>2</sup> 17.06.2-ee-[3-14]



# Getting Started
 
```

1. Install terraform
2. Create a folder named files in the project directory.
2. Edit secret.tfvars as the example file, to set AWS credentials.
2. Run terraform init
3. Edit the variables in install.py
4. Run terraform apply with python install.py

```
# Features

* Installs a license file in the files folder.
* Can provision and join ucp managers, windows ucp workers and linux ucp workers.
* Can provision one DTR instance.
* After cluster setup (on macos) the self-signed CA Root ceritificate is installed to the local keychain.

# Issues
* DTR HA. Currently cannot join multiple DTR replicas automatically.

# Todo

* Support full HA setup with load balancer and provision custom TLS certificates.
* All Docker EE versions and RPM paths are hardcoded into the variables.tf file. It would be better given a Subscription URL to retrieve all possible releases automaticlly using HTTP.

# Example 1.

The example below will provision 4 node cluster consisting of 1 Manager 3 Worker nodes.

The manager will be hosted on a RHEL 7.5 machine with the Docker EE Engine 17.06.2-ee-14 release.
The worker nodes will be hosted on Windows Server 2016 with the same EE engine version as the linux one.

``` (install.py)

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

# Example 2.
Say for some reason you'd like to setup a Docker EE cluster with Engine 17.06.2-ee-12 with a compatible UCP version.

* You provision a ucp cluster topology: 1 manager, 1 linux worker + 1 windows worker.
* You configure the UCP Layer 7 routing solution.
* You deploy services and update them.


# Release notes links

https://success.docker.com/article/compatibility-matrix

https://docs.docker.com/ee/engine/release-notes/

https://docs.docker.com/ee/ucp/release-notes/

https://docs.docker.com/ee/dtr/release-notes/
