provider "azurerm" {
  features {}
}



resource "azurerm_windows_virtual_machine" "winssh" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.winssh.name
  location            = azurerm_resource_group.winssh.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  custom_data         = base64encode("Hello World!")
  network_interface_ids = [
    azurerm_network_interface.winsshnic.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter-with-Containers"
    version   = "latest"
  }

  winrm_listener {
    protocol = "Https"
  }
}


