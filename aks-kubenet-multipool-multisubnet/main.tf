provider "azurerm" {
}

resource "azurerm_resource_group" "aksrg" {
  name     = var.resource_group_name
  location = "West Europe"
}

resource "azurerm_virtual_network" "aks-vnet" {
  name                = "aks-vnet"
  location            = azurerm_resource_group.aksrg.location
  resource_group_name = azurerm_resource_group.aksrg.name
  address_space       = ["172.20.0.0/16"]

}

resource "azurerm_subnet" "akssubnetbase" {
  name                 = "akssubnetbase"
  resource_group_name  = azurerm_resource_group.aksrg.name
  virtual_network_name = azurerm_virtual_network.aks-vnet.name
  address_prefix       = "172.20.1.0/24"
}

resource "azurerm_subnet" "akssubnetextra" {
  name                 = "akssubnetextra"
  resource_group_name  = azurerm_resource_group.aksrg.name
  virtual_network_name = azurerm_virtual_network.aks-vnet.name
  address_prefix       = "172.20.2.0/24"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks"
  location            = azurerm_resource_group.aksrg.location
  resource_group_name = azurerm_resource_group.aksrg.name
  dns_prefix          = "aks"
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.akssubnetbase.id
  }

  addon_profile {
    kube_dashboard {
      enabled = false
    }
  }

  network_profile {
    network_plugin     = "kubenet"
    network_policy     = "calico"
    service_cidr       = "10.0.0.0/16"
    docker_bridge_cidr = "172.17.0.1/16"
    dns_service_ip     = "10.0.0.10"
    load_balancer_sku  = "Standard"
  }
  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }
}


resource "azurerm_kubernetes_cluster_node_pool" "extra" {
  name                  = "extra"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.aks.id
  vm_size               = "Standard_DS2_v2"
  node_count            = 1
  vnet_subnet_id        = azurerm_subnet.akssubnetextra.id

}


locals {
  agents_resource_group_name = "MC_${azurerm_resource_group.aksrg.name}_${azurerm_kubernetes_cluster.aks.name}_${azurerm_resource_group.aksrg.location}"
}

data "azurerm_resource_group" "agents" {
  name = "${local.agents_resource_group_name}"

  depends_on = [
    azurerm_kubernetes_cluster.aks,
  ]
}

data "external" "get-namesuffix" {
  program = ["/bin/sh", "${path.module}/get_nameSuffix.sh"]

  query = {
    rg_name  = azurerm_resource_group.aksrg.name
    aks_name = azurerm_kubernetes_cluster.aks.name
  }

}

data "azurerm_route_table" "aksrt" {
  name                = "aks-agentpool-${data.external.get-namesuffix.result.nameSuffix}-routetable"
  resource_group_name = "${local.agents_resource_group_name}"
}

resource "azurerm_subnet_route_table_association" "akssubnetbase" {
  subnet_id      = azurerm_subnet.akssubnetbase.id
  route_table_id = data.azurerm_route_table.aksrt.id
}

resource "azurerm_subnet_route_table_association" "akssubnetextra" {
  subnet_id      = azurerm_subnet.akssubnetextra.id
  route_table_id = data.azurerm_route_table.aksrt.id
}

output "nameSuffix" {
  value = "${data.external.get-namesuffix.result.nameSuffix}"
}

output "agents_resource_group_name" {
  value = "${local.agents_resource_group_name}"
}


output "client_certificate" {
  value = azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
}
