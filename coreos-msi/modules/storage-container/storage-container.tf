variable "resource_group_name" {
  type        = "string"
  description = "Resource group name"
}

variable "storage_account_name" {
  type        = "string"
  description = "storage_account_name"
}

variable "storage_container_name" {
  description = "The name of the storage container"
}

resource "azurerm_storage_container" "ignition" {
  resource_group_name  = "${var.resource_group_name}"
  storage_account_name = "${var.storage_account_name}"
  name                 = "${var.storage_container_name}"
}

output "name" {
  value = "${azurerm_storage_container.ignition.name}"
}

output "id" {
  value = "${azurerm_storage_container.ignition.id}"
}
