variable "location" {
  description = "The Azure Region in which all resources in this example should be provisioned"
  default     = "West Europe"
}

variable "rg_name" {
  description = "The Azure Resource Group name"
  default     = "akstf"
}

variable "vnet_name" {
  description = "The Azure vnet name"
  default     = "akstfnet"
}

variable "dns_servers" {
  description = "The DNS servers to be used with vNet."
  default     = []
}

variable "address_space" {
  description = "Vnet address space"
  default     = "10.0.0.0/16"
}

variable "subnet_prefixes" {
  description = "subnet prefixes"
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "subnet_names" {
  description = "subnet names"
  default     = ["subnet1", "subnet2", "subnet3"]
}

variable "vm_name" {
  description = "VM name"
  default     = "vm1"
}

variable "vm_size" {
  description = "VM Size"
  default     = "Standard_B2ms"
}
