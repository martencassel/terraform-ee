variable "region" {
  default = "eu-central-1"
}

variable "access_key" {}

variable "secret_key" {}

variable "rhsm_username" {}

variable "rhsm_password" {}

variable "manager_count" {}

variable "ami_os_list" {
  type = "map"

  default = {
    "RHEL-7.3" = "ami-e4c63e8b"
    "RHEL-7.4" = "ami-d74be5b8"
    "RHEL-7.5" = "ami-c86c3f23"
  }
}

variable "os_version" {}
