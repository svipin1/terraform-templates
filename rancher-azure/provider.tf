# Terraform provider

# Rancher
provider "rancher2" {
  api_url   = var.rancher_url
  token_key = var.rancher_token
  insecure  = false
}
