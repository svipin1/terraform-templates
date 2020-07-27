variable "resource_group_name" {
  description = "resource_group_name"
  default     = ""
}

variable "location" {
  description = "location"
  default     = ""
}

variable "nfs_vnet_address_space" {
  description = "nfs_vnet_address_space"
  default     = ""
}

variable "nfs_vnet_subnet_address_prefix" {
  description = "nfs_vnet_subnet_address_prefix"
  default     = ""
}

variable "peervnet" {
  description = "peervnet"
  default     = ""
}

variable "peervnetrg" {
  description = "peervnetrg"
  default     = ""
}