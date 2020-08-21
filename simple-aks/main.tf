resource "azurerm_resource_group" "aks_rg" {
  location = var.location
  name     = "${var.rg_name == "" ? var.cluster_name : var.rg_name}"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.cluster_name
  resource_group_name = azurerm_resource_group.aks_rg.name
  location            = azurerm_resource_group.aks_rg.location
  dns_prefix          = var.cluster_name

  kubernetes_version = var.kubernetes_version

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_B4ms"
  }

  role_based_access_control {
    enabled = true
  }
  identity {
    type = "SystemAssigned"
  }

  linux_profile {
    admin_username = "azureuser"
    ssh_key {
      key_data = var.ssh_key_data
    }
  }

  network_profile {
    network_plugin = "kubenet"
    network_policy = "calico"
  }
}