# Configure AWS Provider
provider "aws" {
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
  region     = "${var.region}"
}

# Script templates
data "template_file" "rhel_init" {
  template = "${file("./scripts/rhel_init.tpl")}"

  vars = {
    rhsm_username = "${var.rhsm_username}"
    rhsm_password = "${var.rhsm_password}"
  }
}

data "template_file" "rhel_ee_install" {
  template = "${file("./scripts/rhel_ee_install.tpl")}"

  vars = {
    docker_ee_url = "${var.docker_ee_url}"
    package_path  = "${lookup(var.ee_version_packages, var.ee_version)}"
  }
}

data "template_file" "install_ucp" {
  template = "${file("./scripts/install_ucp.tpl")}"

  vars = {
    ucp_version    = "${var.ucp_version}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }
}

resource "aws_instance" "ucp_manager" {
  ami           = "${lookup(var.ami_os_linux_list, var.os_version)}"
  instance_type = "t2.large"
  count         = "${var.manager_count}"
  key_name      = "terraform"

  tags = {
    Name    = "manager-${count.index}"
    Version = "${var.ucp_version}"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("~/aws/terraform.pem")}"
  }

  # Render provisioning scripts
  provisioner "file" {
    content     = "${data.template_file.rhel_init.rendered}"
    destination = "/tmp/rhel_init.sh"
  }

  provisioner "file" {
    content     = "${data.template_file.rhel_ee_install.rendered}"
    destination = "/tmp/rhel_ee_install.sh"
  }

  # Render licensefile for UCP install
  provisioner "file" {
    source      = "./files/docker_subscription.lic"
    destination = "/tmp/docker_subscription.lic"
  }

  provisioner "file" {
    content     = "${data.template_file.install_ucp.rendered}"
    destination = "/tmp/install_ucp.sh"
  }

  # Run provisioning scripts
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/rhel_init.sh",
      "/tmp/rhel_init.sh",
      "chmod +x /tmp/rhel_ee_install.sh",
      "/tmp/rhel_ee_install.sh",
      "chmod +x /tmp/install_ucp.sh",
      "/tmp/install_ucp.sh ${count.index} ${self.private_ip} ${aws_instance.ucp_manager.0.private_ip} ${aws_instance.ucp_manager.0.public_dns}",
    ]
  }

  provisioner "local-exec" {
    command = "curl -k https://${aws_instance.ucp_manager.0.public_dns}/ca > ./files/ucp_ca.pem; sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ./files/ucp_ca.pem"
  }
}

data "template_file" "join_worker" {
  template = "${file("./scripts/join_worker.tpl")}"

  vars = {
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }
}

resource "aws_instance" "ucp_worker" {
  depends_on = ["aws_instance.ucp_manager"]

  ami           = "${lookup(var.ami_os_linux_list, var.os_version)}"
  instance_type = "t2.large"
  count         = "${var.linux_worker_count}"
  key_name      = "terraform"

  tags = {
    Name    = "worker-${count.index}"
    Version = "${var.ucp_version}"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("~/aws/terraform.pem")}"
  }

  # Render provisioning scripts
  provisioner "file" {
    content     = "${data.template_file.rhel_init.rendered}"
    destination = "/tmp/rhel_init.sh"
  }

  provisioner "file" {
    content     = "${data.template_file.rhel_ee_install.rendered}"
    destination = "/tmp/rhel_ee_install.sh"
  }

  provisioner "file" {
    content     = "${data.template_file.join_worker.rendered}"
    destination = "/tmp/join_worker.sh"
  }

  # Run provisioning scripts
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/rhel_init.sh",
      "/tmp/rhel_init.sh",
      "chmod +x /tmp/rhel_ee_install.sh",
      "/tmp/rhel_ee_install.sh",
      "chmod +x /tmp/join_worker.sh",
      "/tmp/join_worker.sh ${count.index} ${self.private_ip} ${aws_instance.ucp_manager.0.private_ip} ${aws_instance.ucp_manager.0.public_dns}",
    ]
  }
}

data "template_file" "install_dtr" {
  template = "${file("./scripts/install_dtr.tpl")}"

  vars = {
    dtr_version    = "${var.dtr_version}"
    admin_username = "${var.admin_username}"
    admin_password = "${var.admin_password}"
  }
}

resource "aws_instance" "dtr_replica" {
  depends_on = ["aws_instance.ucp_manager"]

  ami           = "${lookup(var.ami_os_linux_list, var.os_version)}"
  instance_type = "t2.large"
  count         = "${var.dtr_count}"
  key_name      = "terraform"

  tags = {
    Name = "dtr-replica-${count.index}.${var.ucp_version}"
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("~/aws/terraform.pem")}"
  }

  # Render provisioning scripts
  provisioner "file" {
    content     = "${data.template_file.rhel_init.rendered}"
    destination = "/tmp/rhel_init.sh"
  }

  provisioner "file" {
    content     = "${data.template_file.rhel_ee_install.rendered}"
    destination = "/tmp/rhel_ee_install.sh"
  }

  provisioner "file" {
    content     = "${data.template_file.install_dtr.rendered}"
    destination = "/tmp/install_dtr.sh"
  }

  # Run provisioning scripts
  provisioner "remote-exec" {
    inline = [
      "chmod +x /tmp/rhel_init.sh",
      "/tmp/rhel_init.sh",
      "chmod +x /tmp/rhel_ee_install.sh",
      "/tmp/rhel_ee_install.sh",
      "chmod +x /tmp/install_dtr.sh",
      "/tmp/install_dtr.sh ${count.index} ${self.private_ip} ${self.private_dns} ${aws_instance.ucp_manager.0.private_ip} ${aws_instance.ucp_manager.0.public_dns}",
    ]
  }

  provisioner "local-exec" {
    command = "curl -k https://${aws_instance.dtr_replica.0.public_dns}/ca > ./files/dtr_ca.pem; sudo security add-trusted-cert -d -r trustRoot -k /Library/Keychains/System.keychain ./files/dtr_ca.pem"
  }
}
