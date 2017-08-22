#!/bin/bash

# You need kubectl installed beforehand.
# $1: IP address of the master machine

# kubectl config set-credentials k8sdemo/openstack --username=centos --client-key=~/.ssh/id_rsa
# kubectl config set-cluster k8sdemo/openstack --server https://$1:6443
# kubectl config set-context k8sdemo/openstack --user=k8sdemo/openstack --cluster=k8sdemo/openstack
# kubectl config use-context k8sdemo/openstack

mkdir k8s_credentials
ssh centos@$1 sudo cat /etc/kubernetes/ssl/ca.pem > k8s_credentials/ca.pem
ssh centos@$1 sudo cat /etc/kubernetes/ssl/admin-k8s-master-key.pem > k8s_credentials/admin-k8s-master-key.pem
ssh centos@$1 sudo cat /etc/kubernetes/ssl/admin-k8s-master.pem > k8s_credentials/admin-k8s-master.pem

kubectl config set-cluster k8sdemo/openstack --server=https://$1:6443 \
            --certificate-authority=k8s_credentials/ca.pem

kubectl config set-credentials k8sdemo/openstack \
            --username=centos --client-key=~/.ssh/id_rsa \
            --certificate-authority=k8s_credentials/ca.pem \
            --client-key=k8s_credentials/admin-k8s-master-key.pem \
            --client-certificate=k8s_credentials/admin-k8s-master.pem

kubectl config set-context k8sdemo/openstack --cluster=k8sdemo/openstack --user=k8sdemo/openstack
kubectl config use-context k8sdemo/openstack
