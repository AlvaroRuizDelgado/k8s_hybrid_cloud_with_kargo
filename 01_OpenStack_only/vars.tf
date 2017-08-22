variable "openstack_ext_gw" {
  description = "Identity of the public network."
  default = "280c3727-3403-48de-a507-09753b85595f"
  type = "string"
}

variable "node-count" {
  description = ""
  default = "2"
  type = "string"
}

variable "floating-ip-pool" {
  description = ""
  default = "public"
  type = "string"
}

variable "image-name" {
  description = "Name of the image in OpenStack."
  default = "CentOS-7-x86_64-GenericCloud-1704"
  type = "string"
}

variable "image-flavor" {
  description = ""
  default = "m1.small"
  type = "string"
}

variable "security-groups" {
  description = ""
  default = "default,k8s-sg"
  type = "string"
}

variable "key-pair" {
  description = ""
  default = "mykey"
  type = "string"
}
