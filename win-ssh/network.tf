resource "azurerm_virtual_network" "winsshvnet" {
  name                = "winsshvnet"
  location            = azurerm_resource_group.winssh.location
  resource_group_name = azurerm_resource_group.winssh.name
  address_space       = var.address_space

}

resource "azurerm_subnet" "winsshsubnet" {
  resource_group_name  = azurerm_resource_group.winssh.name
  virtual_network_name = azurerm_virtual_network.winsshvnet.name
  name                 = "winsshsubnet"
  address_prefix       = var.subnet_prefix
}

resource "azurerm_public_ip" "winssh" {
  name                = "winssh"
  location            = azurerm_resource_group.winssh.location
  resource_group_name = azurerm_resource_group.winssh.name
  allocation_method   = "Static"
}


resource "azurerm_network_interface" "winsshnic" {
  name                = "winsshnic"
  location            = azurerm_resource_group.winssh.location
  resource_group_name = azurerm_resource_group.winssh.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.winsshsubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.winssh.id
  }
}

resource "azurerm_network_security_group" "winssh" {
  name                = "winssh"
  location            = azurerm_resource_group.winssh.location
  resource_group_name = azurerm_resource_group.winssh.name
}

resource "azurerm_network_security_rule" "rdp" {
  name                        = "rdp"
  priority                    = 100
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "3389"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.winssh.name
  network_security_group_name = azurerm_network_security_group.winssh.name
}

resource "azurerm_network_security_rule" "ssh" {
  name                        = "ssh"
  priority                    = 101
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.winssh.name
  network_security_group_name = azurerm_network_security_group.winssh.name
}

resource "azurerm_network_security_rule" "winrm" {
  name                        = "winrm"
  priority                    = 102
  direction                   = "Outbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "5586"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.winssh.name
  network_security_group_name = azurerm_network_security_group.winssh.name
}