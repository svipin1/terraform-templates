resource "azurerm_relay_namespace" "cloudshellrelay" {
  name                = "cloudshellrelay"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  sku_name = "Standard"
}