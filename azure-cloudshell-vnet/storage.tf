resource "random_string" "random" {
  length = 4
  upper = false
  special = false
}



resource "azurerm_storage_account" "cloudshell" {
  name                = "cloudshel${random_string.random.result}"
  resource_group_name = data.azurerm_resource_group.rg.name

  location                 = data.azurerm_resource_group.rg.location
  account_kind             = "StorageV2"
  account_tier             = "Standard"
  account_replication_type = "LRS"
  access_tier              = "Cool"

  enable_https_traffic_only = true

  network_rules {
    default_action             = "Deny"
    bypass                     = ["None"]
    virtual_network_subnet_ids = [azurerm_subnet.cloudshell.id, azurerm_subnet.shell.id]
  }

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "shell" {
  name                  = "default"
  storage_account_name  = azurerm_storage_account.cloudshell.name
  container_access_type = "private"
}

resource "azurerm_storage_share" "cloudshell" {
  name                 = "default"
  storage_account_name = azurerm_storage_account.cloudshell.name
  quota                = 6
}
