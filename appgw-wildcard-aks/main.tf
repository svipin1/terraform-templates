provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

module "network" {
  source                           = "./modules/network"
  resource_group_name              = var.resource_group_name
  location                         = var.location
  location_c1                      = var.location_c1
  location_c2                      = var.location_c2
  appgw_vnet_address_space         = var.appgw_vnet_address_space
  appgw_vnet_subnet_address_prefix = var.appgw_vnet_subnet_address_prefix
  c1_vnet_address_space            = var.c1_vnet_address_space
  c1_vnet_subnet_address_prefix    = var.c1_vnet_subnet_address_prefix
  c2_vnet_address_space            = var.c2_vnet_address_space
  c2_vnet_subnet_address_prefix    = var.c2_vnet_subnet_address_prefix
}

module "appgw" {
  source                      = "./modules/appgw"
  resource_group_name         = var.resource_group_name
  location                    = var.location
  gateway_ip_configuration_id = module.network.gateway_ip_configuration_id
  fqdn1                       = var.fqdn1
  fqdn2                       = var.fqdn2
}

module "aks_c1" {
  source              = "./modules/aks"
  resource_group_name = var.resource_group_name
  location            = var.location
}

module "aks_c2" {
  source              = "./modules/aks"
  resource_group_name = var.resource_group_name
  location            = var.location
}