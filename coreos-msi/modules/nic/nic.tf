variable "resource_group_name" {
  type        = "string"
  description = "Resource group name"
}

variable "location" {
  type        = "string"
  description = "Resource group location"
}

variable "vm_name" {
  description = "The name of the vn"
}

variable "network_security_group_id" {
  type        = "string"
  description = "NSG id"
}

variable "subnet_id" {
  type        = "string"
  description = "Subnet id"
}

variable "public_ip_address_id" {
  type        = "string"
  description = "Pub IP id"
}

resource "azurerm_network_interface" "coreos-nic" {
  name                = "${var.vm_name}-nic"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"

  network_security_group_id     = "${var.network_security_group_id}"
  enable_ip_forwarding          = true
  enable_accelerated_networking = false

  ip_configuration {
    name                          = "${var.vm_name}-nic-ipconfig"
    subnet_id                     = "${var.subnet_id}"
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = "${var.public_ip_address_id}"
  }
}

output "id" {
  value = "${azurerm_network_interface.coreos-nic.id}"
}
