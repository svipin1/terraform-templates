variable "resource_group_name" {
  type        = "string"
  description = "Resource group name"
}

variable "location" {
  type        = "string"
  description = "Resource group location"
}

variable "storage_account_name" {
  type        = "string"
  description = "The name of the storage account"
}

resource "azurerm_storage_account" "coreos" {
  name                     = "${var.storage_account_name}"
  resource_group_name      = "${var.resource_group_name}"
  location                 = "${var.location}"
  account_tier             = "Standard"                    #premium will silently fail blob upload (Block blobs are not supported.)
  account_replication_type = "LRS"
}

output "name" {
  value = "${azurerm_storage_account.coreos.name}"
}
