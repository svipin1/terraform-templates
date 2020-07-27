resource "azurerm_virtual_network" "nfs-vnet" {
  name                = "nfs-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = var.nfs_vnet_address_space
}

resource "azurerm_subnet" "nfs-subnet" {
  name                 = "nfs-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.nfs-vnet.name
  address_prefixes     = var.nfs_vnet_subnet_address_prefix
}

data "azurerm_virtual_network" "remotevnet" {
  name                = var.peervnet
  resource_group_name = var.peervnetrg
}

resource "azurerm_virtual_network_peering" "nfs2remote" {
  name                      = "nfs2remote"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = azurerm_virtual_network.nfs-vnet.name
  remote_virtual_network_id = data.azurerm_virtual_network.remotevnet.id
}

resource "azurerm_virtual_network_peering" "remote2nfs" {
  name                      = "remote2nfs"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = data.azurerm_virtual_network.remotevnet.name
  remote_virtual_network_id = azurerm_virtual_network.nfs-vnet.id
}