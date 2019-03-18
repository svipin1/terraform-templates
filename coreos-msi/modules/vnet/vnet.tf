variable "resource_group_name" {
  type        = "string"
  description = "Resource group name"
}

variable "location" {
  type        = "string"
  description = "Resource group location"
}

variable "vnet_name" {
  type        = "string"
  description = "vnet name"
}

variable "address_space" {
  type        = "string"
  description = "vnet CIDR"
}

resource "azurerm_virtual_network" "coreos-vnet" {
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  name                = "${var.vnet_name}-vnet"

  address_space = [
    "${var.address_space}",
  ]
}

output "name" {
  value = "${azurerm_virtual_network.coreos-vnet.name}"
}
