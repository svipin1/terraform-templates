variable "azure_tenant_id" {}

variable "azure_subscription_id" {}

variable "resource_group_name" {
  default     = "coreos-msi"
  description = "Resource group name"
}

variable "resource_group_location" {
  type        = "string"
  default     = "westeurope"
  description = "Resource group location"
}

variable "contact" {
  type        = "string"
  description = "a contact"
}

variable "virtual_network_name" {
  type        = "string"
  default     = "coreos"
  description = "The VNET name"
}

variable "vnet_cidr" {
  type        = "string"
  default     = "10.10.0.0/16"
  description = "The VNET CIDR"
}

variable "subnet_name" {
  type        = "string"
  default     = "coreos"
  description = "The subnet name"
}

variable "subnet_cidr" {
  type        = "string"
  default     = "10.10.10.0/24"
  description = "The subnet CIDR"
}

variable "nsg_name" {
  type        = "string"
  default     = "coreos"
  description = "The NSG suffix"
}

variable "pubip-name" {
  type        = "string"
  default     = "coreos"
  description = "The pubip suffix"
}

variable "domain_name_label" {
  type        = "string"
  default     = "coreosmsi"
  description = "The DNS name for the public ip"
}

variable "cloudconfig_file" {
  description = "The location of the cloud init configuration file."
  default = "./cloudconfig.tpl"
}

variable "storage_account_name" {
  description = "The name of the storage account"
  default = "coreos1"
}

variable "storage_container_name" {
  description = "The name of the storage container"
  default = "ignition"
}

variable "storage_blob_name" {
  description = "The name of the storage blob"
  default = "ignition"
}

variable "identity_name" {
  description = "The name of the user managed identity"
  default = "ignition"
}


variable "role_name" {
  description = "The name of the role assigned to the user managed identity"
  default = "Owner"
}


variable "vm_name" {
  description = "The name of the vn"
  default = "coreos"
}

variable "vm_size" {
  description = "The name of the vn"
  default = "Standard_DS1_v2"
}

variable "vm_publisher" {
  type        = "string"
  description = "vm publisher"
  default = "CoreOS"
}
variable "vm_offer" {
  type        = "string"
  description = "vm offer"
  default = "CoreOS"
}
variable "vm_sku" {
  type        = "string"
  description = "vm sku"
  default = "Stable"
}
variable "vm_version" {
  type        = "string"
  description = "vm version"
  default = "latest"
}

variable "vm_disk_type" {
  type        = "string"
  description = "vm disk type"
  default = "Standard_LRS"
}

variable "ssh_key" {
  type        = "string"
  description = "vm disk type"
}