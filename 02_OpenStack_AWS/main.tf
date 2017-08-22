# ##Setup needed variables
# variable "node-count" {}
# variable "floating-ip-pool" {}
# variable "image-name" {}
# variable "image-flavor" {}
# variable "security-groups" {}
# variable "key-pair" {}

# ---------- PROVIDERS -----------

provider "aws" {
  region = "${var.aws_region}"
}

variable "password" {}
variable "user_name" {}
variable "tenant_name" {}
variable "auth_url" {}

provider "openstack" {
  user_name   = "${var.user_name}"
  tenant_name = "${var.tenant_name}"
  password    = "${var.password}"
  auth_url    = "${var.auth_url}"
}

# ------------- OPENSTACK ------------------

resource "openstack_networking_router_v2" "router" {
  name = "k8s-demo-router"
  admin_state_up = "true"
  external_gateway = "${var.openstack_ext_gw}"
}

### [Web networking] ###

resource "openstack_networking_network_v2" "net_k8s" {
  name = "net-k8s-demo"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_k8s" {
  name = "subnet-k8s-demo"
  network_id = "${openstack_networking_network_v2.net_k8s.id}"
  cidr = "10.0.0.0/24"
  ip_version = 4
  enable_dhcp = "true"
  dns_nameservers = ["8.8.8.8","8.8.4.4"]
}

resource "openstack_networking_router_interface_v2" "web-ext-interface" {
  router_id = "${openstack_networking_router_v2.router.id}"
  subnet_id = "${openstack_networking_subnet_v2.subnet_k8s.id}"
}

# ----- MASTER NODE ------

##Create a single master node and floating IP
resource "openstack_compute_floatingip_v2" "master-ip" {
  pool = "${var.floating-ip-pool}"
}

resource "openstack_compute_instance_v2" "k8s-master" {
  name = "k8s-master"
  image_name = "${var.image-name}"
  flavor_name = "${var.image-flavor}"
  key_pair = "${var.key-pair}"
  security_groups = ["${split(",", var.security-groups)}"]
  network {
    uuid = "${openstack_networking_network_v2.net_k8s.id}"
  }
  floating_ip = "${openstack_compute_floatingip_v2.master-ip.address}"
}

# ##Create a single master node and floating IP
# resource "openstack_compute_instance_v2" "k8s-master" {
#   name = "k8s-master"
#   image_name = "${var.image-name}"
#   flavor_name = "${var.image-flavor}"
#   key_pair = "${var.key-pair}"
#   security_groups = ["${split(",", var.security-groups)}"]
#   network {
#     uuid = "${openstack_networking_network_v2.net_k8s.id}"
#   }
#   floating_ip = "${openstack_compute_floatingip_v2.master-ip.address}"
# }
#
# resource "openstack_networking_floatingip_v2" "master-ip" {
#   pool = "${var.floating-ip-pool}"
# }
#
# resource "openstack_compute_floatingip_associate_v2" "master-ip" {
#   floating_ip = "${openstack_networking_floatingip_v2.master-ip.address}"
#   instance_id = "${openstack_compute_instance_v2.k8s-master.id}"
# }


# ----- CLUSTER NODES ------

##Create desired number of k8s nodes and floating IPs
resource "openstack_compute_floatingip_v2" "node-ip" {
  pool = "${var.floating-ip-pool}"
  count = "${var.node-count}"
}

resource "openstack_compute_instance_v2" "k8s-node" {
  count = "${var.node-count}"
  name = "k8s-node-${count.index}"
  image_name = "${var.image-name}"
  flavor_name = "${var.image-flavor}"
  key_pair = "${var.key-pair}"
  security_groups = ["${split(",", var.security-groups)}"]
  network {
    uuid = "${openstack_networking_network_v2.net_k8s.id}"
  }
  floating_ip = "${element(openstack_compute_floatingip_v2.node-ip.*.address, count.index)}"
}

# ------- AWS NODE -------

## [AWS instances] ###

resource "aws_instance" "aws_nodes" {
  provider = "aws"
  count = "${var.aws-node-count}"
  tags {
    name = "demo-aws-${count.index}"
  }

  ami = "${var.centos7_ami}"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["${var.aws-security-groups}"]
  key_name = "${var.aws-keypair}"

  tags {
    name = "demo-aws-${count.index+1}"
  }
}
