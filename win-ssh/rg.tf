resource "azurerm_resource_group" "winssh" {
  name     = var.resource_group_name
  location = var.location
}