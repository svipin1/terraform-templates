# aks-terraform

This Terraform template deploys an AKS cluster in a custom VNET with RBAC and AAD integration enabled; since the support for the latter features is still not in the Terraform Azure Resource Manager provider, it needs to be done via the `azurerm_template_deployment` resource.

Copy the `variables.tfvarsexample` to `variables.tfvars`, edit with your values, and deploy with

```
terraform apply -var-file=variables.tfvars
```

It might take up to 20-25 minutes to deploy, so be patient!
