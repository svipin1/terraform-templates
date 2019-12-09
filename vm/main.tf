/*
comment
*/


terraform {
  backend "azurerm" {
    storage_account_name = "tfme"
    container_name       = "tfstate"
  }
}

terraform {
  required_version = ">= 0.12.0"
}

module "resource_group" {
  source   = "../modules/resource_group/"
  location = "${var.location}"
  name     = "${var.rg_name}"
}

module "vnet" {
  source              = "../modules/vnet/"
  resource_group_name = "${var.rg_name}"
  location            = "${var.location}"
  vnet_name           = "${var.vnet_name}"
  dns_servers         = "${var.dns_servers}"
  address_space       = "${var.address_space}"
  subnet_prefixes     = "${var.subnet_prefixes}"
  subnet_names        = "${var.subnet_names}"
}

/*
resource "azurerm_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = var.rg_name
  vm_size             = var.vm_size
  location            = "${var.location}"

}
*/
