resource "azurerm_private_endpoint" "cloudshellRelayEndpoint" {
  name                = "cloudshellRelayEndpoint"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  subnet_id           = azurerm_subnet.relay.id

  private_service_connection {
    name                           = "relayconnection"
    private_connection_resource_id = azurerm_relay_namespace.cloudshell.id
    is_manual_connection           = false
    subresource_names              = ["namespace"]

  }
}
