resource "azurerm_role_assignment" "network" {
  scope                = azurerm_network_profile.cloudshell.id
  role_definition_id = var.networkRoleDefinitionId
  principal_id         = var.container_istance_objid
}

resource "azurerm_role_assignment" "relay" {
  scope                = azurerm_relay_namespace.cloudshell.id
  role_definition_id = var.contributorRoleDefinitionId
  principal_id         = var.container_istance_objid
}