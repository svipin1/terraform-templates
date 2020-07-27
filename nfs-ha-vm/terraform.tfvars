resource_group_name            = "nfs-ha-vm"
location                       = "westeurope"
nfs_vnet_address_space         = ["10.10.0.0/16"]
nfs_vnet_subnet_address_prefix = ["10.10.0.0/24"]
peervnet                       = "aksvnet"
peervnetrg                     = "k8s"