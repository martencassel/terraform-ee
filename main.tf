# Configure AWS Provider
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

resource "aws_instance" "ucp_manager" {
  ami           = "${lookup(var.ami_os_list, var.os_version)}"
  instance_type = "t2.large"
  count         = "${var.manager_count}"
  key_name      = "terraform"
}
