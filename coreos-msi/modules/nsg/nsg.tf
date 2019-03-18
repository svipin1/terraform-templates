variable "resource_group_name" {
  type        = "string"
  description = "Resource group name"
}

variable "location" {
  type        = "string"
  description = "Resource group location"
}

variable "nsg_name" {
  type        = "string"
  default     = "coreos"
  description = "The NSG suffix"
}

resource "azurerm_network_security_group" "coreos-nsg" {
  name                = "${var.nsg_name}-nsg"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"

  security_rule {
    name                       = "pub_inbound_22_tcp_ssh"
    description                = "Allows inbound internet traffic to 22/TCP (SSH daemon)"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
    access                     = "Allow"
    priority                   = 100
    direction                  = "Inbound"
  }
}

output "id" {
  value = "${azurerm_network_security_group.coreos-nsg.id}"
}
