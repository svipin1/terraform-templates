variable "scope" {
  description = "The role scope"
}

resource "azurerm_role_definition" "blobreadrole" {
  lifecycle {
    ignore_changes = ["role_definition_id"]
  }

  role_definition_id = "${uuid()}"
  name               = "blobreadrole"
  scope              = "${var.scope}"

  permissions {
    actions     = ["Microsoft.Storage/storageAccounts/blobServices/containers/read"]
    not_actions = []
  }

  assignable_scopes = [
    "${var.scope}",
  ]
}

output "id" {
  value = "${azurerm_role_definition.blobreadrole.id}"
}
