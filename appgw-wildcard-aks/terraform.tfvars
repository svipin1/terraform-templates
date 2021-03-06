resource_group_name              = "appgwmultiaks2"
location                         = "westeurope"
location_c1                      = "northeurope"
location_c2                      = "uksouth"
appgw_pubip_label                = "appgwip2"
appgw_vnet_address_space         = ["10.10.0.0/16"]
appgw_vnet_subnet_address_prefix = ["10.10.0.0/24"]
c1_vnet_address_space            = ["10.11.0.0/16"]
c1_vnet_subnet_address_prefix    = ["10.11.0.0/24"]
c2_vnet_address_space            = ["10.12.0.0/16"]
c2_vnet_subnet_address_prefix    = ["10.12.0.0/24"]

fqdn1              = "c1"
fqdn2              = "c2"
kubernetes_version = "1.18.6"
