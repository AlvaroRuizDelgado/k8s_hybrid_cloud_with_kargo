output "k8s master address" {
  value = "${openstack_compute_floatingip_v2.master-ip.address}"
}

output "AWS node address" {
  value = "${aws_instance.aws_nodes.public_ip}"
}
