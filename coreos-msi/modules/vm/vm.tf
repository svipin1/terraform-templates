variable "resource_group_name" {
  type        = "string"
  description = "Resource group name"
}

variable "location" {
  type        = "string"
  description = "Resource group location"
}

variable "network_interface_ids" {
  type        = "string"
  description = "NIC ID"
}

variable "vm_size" {
  type        = "string"
  description = "VM_size"
}

variable "vm_name" {
  type        = "string"
  description = "Name of the VM"
}

variable "publisher" {
  type        = "string"
  description = "vm publisher"
}

variable "offer" {
  type        = "string"
  description = "vm offer"
}

variable "sku" {
  type        = "string"
  description = "vm sku"
}

variable "vm_version" {
  type        = "string"
  description = "vm version"
}

variable "disk_type" {
  type        = "string"
  description = "disk_type"
}

variable "user_identity" {
  type        = "string"
  description = "user identity id"
}

variable "ssh_key" {
  type        = "string"
  description = "ssh key"
}

variable "custom_data" {
  type        = "string"
  description = "custom_data"
}

resource "azurerm_virtual_machine" "coreos" {
  resource_group_name   = "${var.resource_group_name}"
  location              = "${var.location}"
  name                  = "${var.vm_name}"
  network_interface_ids = ["${var.network_interface_ids}"]
  vm_size               = "${var.vm_size}"

  storage_image_reference {
    publisher = "${var.publisher}"
    offer     = "${var.offer}"
    sku       = "${var.sku}"
    version   = "${var.vm_version}"
  }

  storage_os_disk {
    name              = "osdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "${var.disk_type}"
  }

  delete_data_disks_on_termination = "true"

  os_profile {
    computer_name  = "coreos"
    admin_username = "coreos"
  }

  os_profile_linux_config {
    disable_password_authentication = "true"

    ssh_keys = {
      key_data = "${var.ssh_key}"
      path     = "/home/coreos/.ssh/authorized_keys"
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = ["${var.user_identity}"]
  }
}
