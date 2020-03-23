provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "armaks" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_template_deployment" "armaks" {
  name                = "aksarm"
  resource_group_name = azurerm_resource_group.armaks.name

  template_body = file("./aks-arm.json")



  # these key-value pairs are passed into the ARM Template's `parameters` block
  parameters = {
    "clusterName"                  = var.clusterName
    "dnsPrefix"                    = var.dnsPrefix
    "kubernetesVersion" = var.kubernetesVersion
    "linuxAdminUsername"           = var.linuxAdminUsername
    "sshRSAPublicKey"              = var.sshRSAPublicKey
    "servicePrincipalClientId"     = var.servicePrincipalClientId
    "servicePrincipalClientSecret" = var.servicePrincipalClientSecret

  }

  deployment_mode = "Incremental"
}
