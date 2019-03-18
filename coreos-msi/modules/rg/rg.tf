variable "name" {
  type        = "string"
  description = "Resource group name"
}

variable "contact" {
  type        = "string"
  description = "A contact"
}

variable "location" {
  type        = "string"
  description = "Resource group location"
}

resource "azurerm_resource_group" "coreos" {
  name     = "${var.name}"
  location = "${var.location}"

  tags {
    contact = "${var.contact}"
  }
}

output "name" {
  value = "${azurerm_resource_group.coreos.name}"
}
