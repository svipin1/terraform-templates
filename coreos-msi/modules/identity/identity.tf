variable "resource_group_name" {
  type        = "string"
  description = "Resource group name"
}

variable "location" {
  type        = "string"
  description = "Resource group location"
}

variable "name" {
  description = "The name of the user identity"
}

resource "azurerm_user_assigned_identity" "ignition" {
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"
  name                = "${var.name}"
}

output "id" {
  value = "${azurerm_user_assigned_identity.ignition.id}"
}

output "principal_id" {
  value = "${azurerm_user_assigned_identity.ignition.principal_id}"
}
