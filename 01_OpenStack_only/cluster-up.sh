#!/bin/bash

##Create infrastructure and inventory file
echo "Creating infrastructure"
terraform apply

##Run Ansible playbooks
echo "Quick sleep while instances spin up"
sleep 120
echo "Ansible provisioning"
ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -i kargo/inventory/inventory -u centos -b kargo/cluster.yml --private-key ~/.ssh/openstack_rsa
