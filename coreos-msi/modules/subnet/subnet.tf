variable "subnet_name" {
  type        = "string"
  description = "subnet name"
}

variable "resource_group_name" {
  type        = "string"
  description = "Resource group name"
}

variable "virtual_network_name" {
  type        = "string"
  description = "The virtual network name"
}

variable "subnet_cidr" {
  type        = "string"
  description = "subnet CIDR"
}

resource "azurerm_subnet" "coreos-subnet" {
  name                = "${var.subnet_name}-subnet"
  resource_group_name = "${var.resource_group_name}"

  virtual_network_name = "${var.virtual_network_name}"
  address_prefix       = "${var.subnet_cidr}"
}

output "id" {
  value = "${azurerm_subnet.coreos-subnet.id}"
}
