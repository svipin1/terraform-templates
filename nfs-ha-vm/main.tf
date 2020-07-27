provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "nfs-ha-network" {
  source                         = "./modules/nfs-ha-network"
  resource_group_name            = azurerm_resource_group.rg.name
  location                       = var.location
  nfs_vnet_address_space         = var.nfs_vnet_address_space
  nfs_vnet_subnet_address_prefix = var.nfs_vnet_subnet_address_prefix
  peervnet                       = var.peervnet
  peervnetrg                     = var.peervnetrg
}
