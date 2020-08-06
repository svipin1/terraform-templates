
variable "location" {
  description = "Region"
  default     = "westeurope"
}


variable "rg_name" {
  description = "Name of resource group for the AKS cluster. If empty cluster_name will be used instead."
  default     = ""
}

variable "cluster_name" {
  description = "Name for this cluster"
}

variable "kubernetes_version" {
  description = "kubernetes_version"
}

variable "ssh_key_data" {
  description = "ssh_key_data"
}