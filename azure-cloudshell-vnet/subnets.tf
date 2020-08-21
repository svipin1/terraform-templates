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
  enforce_private_link_service_network_policies  = true

}

resource "azurerm_subnet" "storage" {
  name                 = "storage"
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  address_prefixes     = var.storage_subnet_prefix

  service_endpoints = ["Microsoft.Storage"]
}

resource "azurerm_private_endpoint" "cloudshellRelayEndpoint" {
  name                = "cloudshellRelayEndpoint"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.relay.id

  private_service_connection {
    name                           = "relayconnection"
    private_connection_resource_id = azurerm_relay_namespace.cloudshellrelay.id
    is_manual_connection           = false
  }
}