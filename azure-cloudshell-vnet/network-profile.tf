resource "azurerm_network_profile" "cloudshell" {
  name                = "cloudshell"
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name

  container_network_interface {
    name = "cloudshellnic"

    ip_configuration {
      name      = "exampleipconfig"
      subnet_id = azurerm_subnet.cloudshell.id
    }
  }
}