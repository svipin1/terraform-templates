module "aad-user" {
  source      = "./modules/aks-nodepool"
  for_each    = toset(var.pools)
  username    = each.value
  password    = var.password
  domain_name = data.azuread_domains.aad_domains.domains[0].domain_name
}