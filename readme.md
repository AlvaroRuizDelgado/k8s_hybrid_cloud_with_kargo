## Hybrid cloud with Kubernetes

The idea is to install Kubernetes in multiple systems (OpenStack, AWS, GCP) and interconnect them.

I got more than a fair amount of inspiration from Solinea's Spencer Smith's blog.
https://rsmitty.github.io/Terraform-Ansible-Kubernetes/

### 1) Download kargo into your project's folder

The kargo project has many Ansible playbooks for different situations. We are going to be using that, so we should first download the code to the project folder.
```shell
git clone git@github.com:kubespray/kargo.git
```

### 2) Credentials

First of all we need to give Terraform the appropriate credentials for each of the cloud systems we are using.

Check how to do that in one of my previous projects:
https://github.com/AlvaroRuizDelgado/Terraform_demo_hybrid_cloud

### 3) Infrastructure creation with Terraform

Modify the vars.tf file to adjust the keypair names and the number of nodes you want, and run it.
```shell
terraform apply
```
It may take a few minutes and the infrastructure will be ready for installation.

### 4) Kubernetes setup with Ansible

The inventory should be automatically created and available in kargo/inventory/inventory. After that we need to start the ansible playbook.

```shell
ansible-playbook -i kargo/inventory/inventory -u ubuntu -b kargo/cluster.yml --private-key ~/.ssh/YOUR_SETUP_KEY_rsa
```

## Kubectl

The current kargo kubectl version gives warnings on duplicate proto types registered, we can download the official version to get rid of them.
https://kubernetes.io/docs/tasks/tools/install-kubectl/#install-kubectl-binary-via-curl
```shell
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
```

## Kubectl configuration

The configuration is not done automatically.
https://github.com/kubernetes-incubator/kubespray/issues/257

I prepared a small script to retrieve the certificates from the master and configure kubectl.
```shell
./configure_cluster.sh
```

Possible solution:
https://github.com/CiscoCloud/kubernetes-ansible/issues/105
