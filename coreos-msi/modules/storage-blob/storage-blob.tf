variable "resource_group_name" {
  type        = "string"
  description = "Resource group name"
}

variable "storage_account_name" {
  description = "The name of the storage account"
}

variable "storage_container_name" {
  description = "The name of the storage container"
}

variable "storage_blob_name" {
  description = "The name of the storage blob"
}

variable "content" {
  description = "The content of the storage blob"
}

resource "local_file" "ignition_file" {
  content  = "${var.content}"
  filename = "ignition"
}

resource "azurerm_storage_blob" "ignition" {
  name                   = "${var.storage_blob_name}"
  resource_group_name    = "${var.resource_group_name}"
  storage_account_name   = "${var.storage_account_name}"
  storage_container_name = "${var.storage_container_name}"

  type   = "block"
  source = "./ignition"
}
