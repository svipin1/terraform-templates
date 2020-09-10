variable "azure_client_id" {
}

variable "azure_client_secret" {
}

variable "azure_subscription_id" {
}

variable "azure_tenant_id" {
}

provider "acme" {
  server_url = "https://acme-v02.api.letsencrypt.org/directory"
}

variable "domain" {
  description = "Domain name, can be wildcard"
}

resource "tls_private_key" "private_key" {
  algorithm = "RSA"
}

resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = "alessandro.vozza@microsoft.com"
}

resource "acme_certificate" "certificate" {
  account_key_pem = acme_registration.reg.account_key_pem
  common_name     = var.domain

  dns_challenge {
    provider = "azure"

    config = {
      AZURE_CLIENT_ID         = var.azure_client_id
      AZURE_CLIENT_SECRET     = var.azure_client_secret
      AZURE_SUBSCRIPTION_ID   = var.azure_subscription_id
      AZURE_TENANT_ID         = var.azure_tenant_id
  }
 }
}


resource "local_file" "fritzpem" {
    content     = "${acme_certificate.certificate.certificate_pem}${acme_certificate.certificate.issuer_pem}"
    filename = "${path.module}/fritz.pem"
}