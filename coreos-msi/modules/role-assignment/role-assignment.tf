variable "role_definition_name" {
  description = "The name of the role"
}

variable "principal_id" {
  description = "The identity principal id"
}

variable "scope" {
  description = "The role scope"
}

data "azurerm_subscription" "primary" {}

resource "azurerm_role_assignment" "blobread" {
  scope                = "${var.scope}"
  role_definition_name = "${var.role_definition_name}"
  principal_id         = "${var.principal_id}"
}
