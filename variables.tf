variable "region" {
  default = "eu-central-1"
}

variable "access_key" {}

variable "secret_key" {}

variable "rhsm_username" {}

variable "rhsm_password" {}

variable "manager_count" {}
variable "dtr_count" {}
variable "linux_worker_count" {}
variable "windows_worker_count" {}

variable "ami_os_linux_list" {
  type = "map"

  default = {
    "RHEL-7.3" = "ami-e4c63e8b"
    "RHEL-7.4" = "ami-d74be5b8"
    "RHEL-7.5" = "ami-c86c3f23"
  }
}

variable "windows_os_version" {}

variable "ami_os_windows_list" {
  type = "map"

  default = {
    "1709"                 = "ami-55fbc8be"
    "1803"                 = "ami-eff1c204"
    "2016_base_containers" = "ami-b8f5c653"
    "2016_base"            = "ami-63f5c688"
  }
}

variable "os_version" {}
variable "ee_version" {}

variable "docker_ee_url" {}

variable "ee_version_packages" {
  type = "map"

  default = {
    #    "18.03.1-ee-1"  = "7/x86_64/stable/Packages/docker-ee-18.03.1.ee.1-3.el7.x86_64.rpm"
    "17.06.2-ee-14" = "7/x86_64/stable/Packages/docker-ee-17.06.2.ee.14-3.el7.x86_64.rpm"
    "17.06.2-ee-13" = "7/x86_64/stable/Packages/docker-ee-17.06.2.ee.13-3.el7.rhel.x86_64.rpm"
    "17.06.2-ee-12" = "7/x86_64/stable/Packages/docker-ee-17.06.2.ee.12-3.el7.rhel.x86_64.rpm"
    "17.06.2-ee-11" = "7/x86_64/stable/Packages/docker-ee-17.06.2.ee.11-3.el7.rhel.x86_64.rpm"
    "17.06.2-ee-10" = "7/x86_64/stable/Packages/docker-ee-17.06.2.ee.10-3.el7.rhel.x86_64.rpm"
    "17.06.2-ee-9"  = "7/x86_64/stable/Packages/docker-ee-17.06.2.ee.9-0.0.dev.git20180425.235429.0.c76576b.el7.rhel.x86_64.rpm"
    "17.06.2-ee-8"  = "7/x86_64/stable/Packages/docker-ee-17.06.2.ee.8-3.el7.rhel.x86_64.rpm"
    "17.06.2-ee-7"  = "7/x86_64/stable/Packages/docker-ee-17.06.2.ee.7-3.el7.rhel.x86_64.rpm"
    "17.06.2-ee-6"  = "7/x86_64/stable/Packages/docker-ee-17.06.2.ee.6-3.el7.rhel.x86_64.rpm"
    "17.06.2-ee-5"  = "7/x86_64/stable/Packages/docker-ee-17.06.2.ee.5-1.el7.rhel.x86_64.rpm"
    "17.06.2-ee-4"  = "7/x86_64/stable/Packages/docker-ee-17.06.2.ee.4-1.el7.rhel.x86_64.rpm"
    "17.06.2-ee-3"  = "7/x86_64/stable/Packages/docker-ee-17.06.2.ee.3-1.el7.rhel.x86_64.rpm"
    "17.06.1-ee-2"  = "7/x86_64/stable/Packages/docker-ee-17.06.1.ee.2-1.el7.rhel.x86_64.rpm"
    "17.06.1-ee-1"  = "7/x86_64/stable/Packages/docker-ee-17.06.1.ee.1-1.el7.rhel.x86_64.rpm"
  }
}

variable "ucp_version" {}
variable "dtr_version" {}

variable "admin_username" {}
variable "admin_password" {}
variable "windows_admin_username" {}
variable "windows_admin_password" {}
