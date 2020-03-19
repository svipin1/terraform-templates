variable "resource_group_name" {
  default = "winssh"
}

variable "location" {
  default = "westeurope"
}

variable "address_space" {
  default = ["10.0.1.0/16"]
}

variable "subnet_prefix" {
  default = "10.0.1.0/24"
}
variable "vm_name" {
}
variable "vm_size" {
}
variable "admin_username" {
}
variable "admin_password" {
}