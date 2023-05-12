variable "region" {
  type    = string
  default = "eastus"
}

variable "resource_group" {
  type    = string
  default = "devops-catalog-aks"
}

variable "cluster_name" {
  type    = string
  default = "docatalog"
}

variable "dns_prefix" {
  type    = string
  default = "docatalog"
}

variable "k8s_version" {
  type = string
}

variable "min_node_count" {
  type    = number
  default = 1
}

variable "max_node_count" {
  type    = number
  default = 2
}

variable "machine_type" {
  type    = string
  default = "Standard_D2_v2"
}


variable "container_registry_name" {
  type    = string
  default = "devopscatalogacr"
}
