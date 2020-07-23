resource "azurerm_kubernetes_cluster" "example" {
  name                = "c1"
  resource_group_name = var.resource_group_name
  location            = var.location
  dns_prefix          = "c1"

  kubernetes_version = var.kubernetes_version

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_B4ms"
    vnet_subnet_id = var.vnet_subnet_id
  }

  identity {
    type = "SystemAssigned"
  }

  linux_profile {
    admin_username = "azureuser"
    ssh_key {
      key_data = "fake_ssh_key"
    }
  }

  network_profile {
    network_plugin = "kubenet"
    network_policy = "calico"
  }
}