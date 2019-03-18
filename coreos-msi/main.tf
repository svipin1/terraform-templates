provider "azurerm" {
  version = ">= 1.9.0"

  subscription_id = "${var.azure_subscription_id}"
  tenant_id       = "${var.azure_tenant_id}"
}

module "rg" {
  source = "modules/rg"

  name     = "${var.resource_group_name}"
  location = "${var.resource_group_location}"
  contact  = "${var.contact}"
}

module "vnet" {
  source = "modules/vnet"

  vnet_name           = "${var.virtual_network_name}"
  location            = "${var.resource_group_location}"
  address_space       = "${var.vnet_cidr}"
  resource_group_name = "${module.rg.name}"
}

module "subnet" {
  source = "modules/subnet"

  subnet_name          = "${var.subnet_name}"
  subnet_cidr          = "${var.subnet_cidr}"
  resource_group_name  = "${module.rg.name}"
  virtual_network_name = "${module.vnet.name}"
}

module "nsg" {
  source = "modules/nsg"

  resource_group_name = "${module.rg.name}"
  nsg_name            = "${var.nsg_name}"
  location            = "${var.resource_group_location}"
}

module "public-ip" {
  source = "modules/public-ip"

  resource_group_name = "${module.rg.name}"
  pubip-name          = "${var.pubip-name}"
  location            = "${var.resource_group_location}"
  domain_name_label   = "${var.domain_name_label}"
}

data "template_file" "cloudconfig" {
  template = "${file("${var.cloudconfig_file}")}"

  vars {
    contact = "${var.contact}"
  }
}

data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content_type = "text/cloud-config"
    content      = "${data.template_file.cloudconfig.rendered}"
  }
}

module "storage-account" {
  source = "modules/storage-account"

  resource_group_name  = "${module.rg.name}"
  location             = "${var.resource_group_location}"
  storage_account_name = "${var.storage_account_name}"
}

module "storage-container" {
  source = "modules/storage-container"

  resource_group_name    = "${module.rg.name}"
  storage_account_name   = "${module.storage-account.name}"
  storage_container_name = "${var.storage_container_name}"
}

module "storage-blob" {
  source = "modules/storage-blob"

  resource_group_name    = "${module.rg.name}"
  storage_account_name   = "${var.storage_account_name}"
  storage_container_name = "${module.storage-container.name}"
  storage_blob_name      = "${var.storage_blob_name}"
  content                = "${data.template_cloudinit_config.config.rendered}"
}

module "identity" {
  source = "modules/identity"

  resource_group_name        = "${module.rg.name}"
  location                   = "${var.resource_group_location}"
  name                       = "${var.identity_name}"
}

// Because Error: module.role.azurerm_role_assignment.blobread: Preview roles are not supported, we need to assign Owner role to the identity
//module "role" {
//  source = "modules/role"
//
// scope                      = "${module.storage-container.id}"
//}

module "role-assignment" {
  source = "modules/role-assignment"

  role_definition_name         = "${var.role_name}"
  principal_id               = "${module.identity.principal_id}"
  scope                      = "/subscriptions/12c7e9d6-967e-40c8-8b3e-4659a4ada3ef/resourceGroups/coreos-msi/providers/Microsoft.Storage/storageAccounts/coreos1"
}

module "nic" {
  source = "modules/nic"

  resource_group_name        = "${module.rg.name}"
  location                   = "${var.resource_group_location}"
  vm_name                    = "${var.vm_name}"
  network_security_group_id  = "${module.nsg.id}"
  subnet_id                  = "${module.subnet.id}"
  public_ip_address_id       = "${module.public-ip.id}"

}

module "vm" {
  source = "modules/vm"

  resource_group_name    = "${module.rg.name}"
  location               = "${var.resource_group_location}"
  vm_name                = "${var.vm_name}"
  network_interface_ids  = "${module.nic.id}"
  vm_size                   = "${var.vm_size}"
  publisher              = "${var.vm_publisher}"
  offer                  = "${var.vm_offer}"
  sku                    = "${var.vm_sku}"
  vm_version                = "${var.vm_version}"
  disk_type              = "${var.vm_disk_type}"
  user_identity          = "${module.identity.id}"
  ssh_key                = "${var.ssh_key}"
  custom_data            = "${data.template_cloudinit_config.config.rendered}"
}