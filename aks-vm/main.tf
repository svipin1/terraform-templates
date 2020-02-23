provider "azurerm" {
}

resource "azurerm_resource_group" "aksvm" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "aksvnet" {
  name                = "aksvnet"
  location            = azurerm_resource_group.aksvm.location
  resource_group_name = azurerm_resource_group.aksvm.name
  address_space       = ["172.20.0.0/16"]

}

resource "azurerm_subnet" "akssubnet" {
  name                 = "akssubnet"
  resource_group_name  = azurerm_resource_group.aksvm.name
  virtual_network_name = azurerm_virtual_network.aksvnet.name
  address_prefix       = "172.20.1.0/24"
}

resource "azurerm_subnet" "vmsubnet" {
  name                 = "vmsubnet"
  resource_group_name  = azurerm_resource_group.aksvm.name
  virtual_network_name = azurerm_virtual_network.aksvnet.name
  address_prefix       = "172.20.2.0/24"
}

resource "azurerm_kubernetes_cluster" "aks" {
  name                = "aks"
  location            = azurerm_resource_group.aksvm.location
  resource_group_name = azurerm_resource_group.aksvm.name
  dns_prefix          = "aksvm"
  kubernetes_version  = var.kubernetes_version

  default_node_pool {
    name           = "default"
    node_count     = 1
    vm_size        = "Standard_D2_v2"
    vnet_subnet_id = azurerm_subnet.akssubnet.id
  }

  addon_profile {
    kube_dashboard {
      enabled = false
    }
  }

  network_profile {
    network_plugin     = "kubenet"
    network_policy     = "calico"
    load_balancer_sku  = "Standard"
    service_cidr       = "10.0.0.0/16"
    docker_bridge_cidr = "172.17.0.1/16"
    dns_service_ip     = "10.0.0.10"
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }
}

resource "azurerm_public_ip" "aksvm" {
  name                = "aksvm"
  location            = var.location
  resource_group_name = azurerm_resource_group.aksvm.name
  allocation_method   = "Static"
  domain_name_label   = "aksvm00"
}

resource "azurerm_network_interface" "aksvmnic" {
  name                = "aksvmnic"
  location            = azurerm_resource_group.aksvm.location
  resource_group_name = azurerm_resource_group.aksvm.name

  ip_configuration {
    name                          = "aksvmip1"
    subnet_id                     = azurerm_subnet.vmsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.aksvm.id
  }
}

resource "tls_private_key" "sshkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "azurerm_virtual_machine" "aksvm" {
  name                          = "aksvm"
  location                      = var.location
  resource_group_name           = azurerm_resource_group.aksvm.name
  network_interface_ids         = [azurerm_network_interface.aksvmnic.id]
  vm_size                       = "Standard_DS1_v2"
  delete_os_disk_on_termination = true

  storage_os_disk {
    name              = "osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "aksvm"
    admin_username = var.admin_username
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/ubuntu/.ssh/authorized_keys"
      key_data = tls_private_key.sshkey.public_key_openssh
    }
  }
}
resource "null_resource" "aksvmkubeconfig" {


  #https://github.com/hashicorp/terraform/issues/16330

  provisioner "remote-exec" {
    connection {
      host        = azurerm_public_ip.aksvm.ip_address
      type        = "ssh"
      user        = var.admin_username
      private_key = tls_private_key.sshkey.private_key_pem
    }
    inline = [
      "mkdir /home/ubuntu/.kube/"
    ]
  }
  provisioner "file" {
    connection {
      host        = azurerm_public_ip.aksvm.ip_address
      type        = "ssh"
      user        = var.admin_username
      private_key = tls_private_key.sshkey.private_key_pem
    }
    content     = azurerm_kubernetes_cluster.aks.kube_config_raw
    destination = "/home/ubuntu/.kube/config"
  }
}

output "kube_config" {
  value = azurerm_kubernetes_cluster.aks.kube_config_raw
}

output "ssh_private_key" {
  value = tls_private_key.sshkey.private_key_pem
}

output "azurerm_public_ip" {
  value = azurerm_public_ip.aksvm.fqdn
}
