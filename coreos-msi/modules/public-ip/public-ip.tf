variable "resource_group_name" {
  type        = "string"
  description = "Resource group name"
}

variable "location" {
  type        = "string"
  description = "Resource group location"
}

variable "pubip-name" {
  type        = "string"
  default     = "coreos"
  description = "The pubip suffix"
}

variable "domain_name_label" {
  type        = "string"
  default     = "coreosmsi"
  description = "The DNS name for the public ip"
}

resource "azurerm_public_ip" "coreos-publicip" {
  name                = "${var.pubip-name}-nsg"
  resource_group_name = "${var.resource_group_name}"
  location            = "${var.location}"

  public_ip_address_allocation = "static"
  domain_name_label            = "${var.domain_name_label}"
}

output "id" {
  value = "${azurerm_public_ip.coreos-publicip.id}"
}
