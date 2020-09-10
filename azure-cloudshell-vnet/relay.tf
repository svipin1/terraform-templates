resource "azurerm_relay_namespace" "cloudshell" {
  name                = "cloudshellrelay-${random_string.random.result}"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  sku_name = "Standard"
}
