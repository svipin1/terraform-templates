resource "azurerm_kubernetes_cluster" "example" {
  name                = "c1"
  resource_group_name = var.resource_group_name
  location            = var.location
  dns_prefix          = "c1"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_B4ms"
  }

}