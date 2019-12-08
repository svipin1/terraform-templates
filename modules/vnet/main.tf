resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_name
  location            = var.location
  address_space       = ["${var.address_space}"]
  resource_group_name = var.resource_group_name
  dns_servers         = var.dns_servers
}

resource "azurerm_subnet" "subnet" {
  virtual_network_name = azurerm_virtual_network.vnet.name
  resource_group_name  = var.resource_group_name
  name                 = var.subnet_names[count.index]
  address_prefix       = var.subnet_prefixes[count.index]
  count                = length(var.subnet_names)
}
