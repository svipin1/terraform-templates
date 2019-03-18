variable "azure_tenant_id" {}

variable "azure_subscription_id" {}

variable "contact" {}

variable "azure_location" {
  default = "westeurope"
}

variable "resource_group_name" {
  default = "sftp"
}

variable "resource_name_prefix" {
  default = "sftp"
}

variable "vnet_cidr" {
  default = "10.10.0.0/16"
}

variable "sftp_subnet_cidr" {
  default = "10.10.1.0/24"
}

variable "domain_name_label" {
  default = "sftp999"
}

variable "admin_public_key" {}

variable "admin_username" {
  default = "centos"
}

variable "sftp_count" {
  default = "2"
}

variable "sftp_vm_size" {
  default = "Standard_B1ms"
}

variable "sftp_vm_image_publisher" {
  default = "OpenLogic"
}

variable "sftp_vm_image_offer" {
  default = "CentOS"
}

variable "sftp_vm_image_sku" {
  default = "7.6"
}

variable "sftp_vm_image_version" {
  default = "latest"
}

variable "sftp_vm_osdisk_type" {
  default = "Standard_LRS"
}

variable "sftp_vm_osdisk_size_in_gb" {
  default = "30"
}

variable "sftp_vm_name" {
  default = "sftp"
}

variable "cloud_init_script_path" {
  type    = "string"
  default = "/sftpscript.sh"
}

variable "environment_tag" {
  type = "string"
    default = "sftp"
}

variable "environment_usage_tag" {
  type = "string"
    default = "tf"
}
