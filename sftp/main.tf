provider "azurerm" {
  version = ">= 1.3.0"

  subscription_id = "${var.azure_subscription_id}"
  tenant_id       = "${var.azure_tenant_id}"
}

# -----------------------------------------------------------------
# CREATE RESOURCE GROUP
# -----------------------------------------------------------------
resource "azurerm_resource_group" "rg" {
  name     = "${var.resource_group_name}"
  location = "${var.azure_location}"

  tags {
    Contact = "${var.contact}"
  }
}

# -----------------------------------------------------------------
# CREATE AVAILABILTY SETS FOR SFTP VMs
# -----------------------------------------------------------------

resource "azurerm_availability_set" "sftp-as" {
  name                = "sftp-as"
  location            = "${var.azure_location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  managed                      = "true"
  platform_fault_domain_count  = 3
  platform_update_domain_count = 5
}

# -----------------------------------------------------------------
# SETUP VIRTUAL NETWORKS WITH SUBNETS FOR SFTP VMs
# -----------------------------------------------------------------

resource "azurerm_virtual_network" "sftp-vnet" {
  name                = "${var.resource_name_prefix}-vnet"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${var.azure_location}"

  address_space = [
    "${var.vnet_cidr}",
  ]
}

resource "azurerm_subnet" "sftp-subnet" {
  name                = "${var.resource_name_prefix}-sftp-subnet"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  virtual_network_name = "${azurerm_virtual_network.sftp-vnet.name}"
  address_prefix       = "${var.sftp_subnet_cidr}"
}

resource "azurerm_network_security_group" "sftp-nsg" {
  name                = "${var.resource_name_prefix}-sftp-nsg"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${var.azure_location}"

  security_rule {
    name                       = "pub_inbound_22_tcp_ssh"
    description                = "Allows inbound internet traffic to 22/TCP (SSH daemon)"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
    access                     = "Allow"
    priority                   = 100
    direction                  = "Inbound"
  }
}

# -----------------------------------------------------------------
# CREATE PUBLIC IP FOR  SSH ACCESS
# -----------------------------------------------------------------

resource "azurerm_public_ip" "sftp-publicip" {
  name                = "${var.resource_name_prefix}-sftp-publicip"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  location            = "${var.azure_location}"

  allocation_method = "Static"
  sku               = "Standard"
  domain_name_label = "${var.domain_name_label}"
}

# -----------------------------------------------------------------
# CREATE NETWORK INTERFACES FOR SFTP NODES
# -----------------------------------------------------------------

resource "azurerm_network_interface" "sftp-server-nic" {
  count = "${var.sftp_count}"

  name                = "${var.resource_name_prefix}-sftp-server-${format("%03d", count.index + 1)}-nic"
  location            = "${var.azure_location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  network_security_group_id = "${azurerm_network_security_group.sftp-nsg.id}"

  ip_configuration {
    name                          = "${var.resource_name_prefix}-sftp-server-nic-ipconfig"
    subnet_id                     = "${azurerm_subnet.sftp-subnet.id}"
    private_ip_address_allocation = "dynamic"
  }
}

data "template_file" "cloudconfig" {
  template = "${file("${path.root}${var.cloud_init_script_path}")}"
  vars {
    mountpoint="${var.mountpoint}"
    share_name="${var.share_name}"
    share_username="${var.share_username}"
    share_password="${var.share_password}"
  }
}

#https://www.terraform.io/docs/providers/template/d/cloudinit_config.html
data "template_cloudinit_config" "config" {
  gzip          = true
  base64_encode = true

  part {
    content = "${data.template_file.cloudconfig.rendered}"
  }
}

resource "azurerm_virtual_machine" "sftpvm" {
  count                 = "${var.sftp_count}"
  name                  = "${var.sftp_vm_name}${count.index+1}"
  location              = "${var.azure_location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  vm_size               = "${var.sftp_vm_size}"
  availability_set_id   = "${azurerm_availability_set.sftp-as.id}"

  network_interface_ids = [
    "${element(azurerm_network_interface.sftp-server-nic.*.id, count.index)}",
  ]

  storage_image_reference {
    #get appropriate image info with the following command
    #Get-AzureRmVMImageSku -Location westeurope -Offer windowsserver -PublisherName microsoftwindowsserver
    publisher = "${var.sftp_vm_image_publisher}"

    offer   = "${var.sftp_vm_image_offer}"
    sku     = "${var.sftp_vm_image_sku}"
    version = "${var.sftp_vm_image_version}"
  }

  storage_os_disk {
    name              = "${var.sftp_vm_name}${count.index+1}-OSDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }


  os_profile {
    computer_name  = "${var.sftp_vm_name}${count.index+1}"
    admin_username = "${var.admin_username}"
    custom_data    = "${data.template_cloudinit_config.config.rendered}"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/${var.admin_username}/.ssh/authorized_keys"
      key_data = "${var.admin_public_key}"
    }
  }

  tags {
    environment = "${var.environment_tag}"
    usage       = "${var.environment_usage_tag}"
  }
}

resource "azurerm_lb" "sftp-lb" {
  name                = "sftp"
  location              = "${var.azure_location}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  sku = "Standard"

  frontend_ip_configuration {
    name                 = "sftp-pubip"
    public_ip_address_id = "${azurerm_public_ip.sftp-publicip.id}"
  }
}

resource "azurerm_lb_backend_address_pool" "sftp-lb-pool" {
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  loadbalancer_id     = "${azurerm_lb.sftp-lb.id}"
  name                = "sftppool"
}

resource "azurerm_lb_nat_rule" "ssh" {
  count                          = "${var.sftp_count}"
  resource_group_name            = "${azurerm_resource_group.rg.name}"
  loadbalancer_id                = "${azurerm_lb.sftp-lb.id}"
  name                           = "nat-${element(azurerm_network_interface.sftp-server-nic.*.name, count.index)}"
  protocol                       = "Tcp"
  frontend_port                  = "222${count.index}"
  backend_port                   = 22
  frontend_ip_configuration_name = "sftp-pubip"
}



resource "azurerm_network_interface_backend_address_pool_association" "sftp-lb-pool-assoc" {
  count                 = "${var.sftp_count}"
  network_interface_id  = "${element(azurerm_network_interface.sftp-server-nic.*.id, count.index)}"
  ip_configuration_name   = "${var.resource_name_prefix}-sftp-server-nic-ipconfig"
  backend_address_pool_id = "${azurerm_lb_backend_address_pool.sftp-lb-pool.id}"
}

resource "azurerm_network_interface_nat_rule_association" "sftp-lb-nat-assoc" {
  count                   = "${var.sftp_count}"
  network_interface_id    = "${element(azurerm_network_interface.sftp-server-nic.*.id, count.index)}"
  ip_configuration_name   = "${var.resource_name_prefix}-sftp-server-nic-ipconfig"
  nat_rule_id             = "${element(azurerm_lb_nat_rule.ssh.*.id, count.index)}"
}

resource "local_file" "saved-manifesto" {
  content = "${data.template_file.cloudconfig.rendered}"
  filename = "rendered_cloudinit"
}

resource "null_resource" "run" {
  triggers {
    file = "${data.template_file.cloudconfig.rendered}"
  }

  provisioner "local-exec" {
    command = "cat rendered_cloudinit"
  }
}