terraform {
  backend "azurerm" {
    storage_account_name = "tfme"
    container_name       = "tfstatevm"
  }
}
