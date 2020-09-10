resource "azurerm_subnet" "cloudshell" {
  name                 = "cloudshell"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = var.cloudshell_subnet_prefix

  service_endpoints = ["Microsoft.Storage"]

  delegation {
    name = "CloudShellDelegation"

    service_delegation {
      name = "Microsoft.ContainerInstance/containerGroups"
    }
  }
}

resource "azurerm_subnet" "relay" {
  name                 = "relay"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = var.relay_subnet_prefix

  enforce_private_link_endpoint_network_policies = false
  enforce_private_link_service_network_policies  = false

}

resource "azurerm_subnet" "shell" {
  name                 = "shell"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = var.storage_subnet_prefix

  service_endpoints = ["Microsoft.Storage"]
}

