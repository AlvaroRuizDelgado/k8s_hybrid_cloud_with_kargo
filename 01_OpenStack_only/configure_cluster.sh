#!/bin/bash

# You need kubectl installed beforehand.
# $1: IP address of the master machine

kubectl config set-credentials k8sdemo/openstack --username=centos --client-key=~/.ssh/id_rsa
kubectl config set-cluster kuberuiz/openstack --server https://$1:6443
kubectl config set-context k8sdemo/openstack --user=k8sdemo/openstack --cluster=k8sdemo/openstack
kubectl config use-context k8sdemo/openstack
