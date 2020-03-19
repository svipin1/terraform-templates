provider "tfe" {
  hostname = "app.terraform.io" # Terraform Cloud
}

resource "tfe_workspace" "workspace" {
  for_each = var.workspaces

  organization = var.organization_name
  name         = each.key
}

resource "tfe_variable" "envvars" {
  # We'll need one tfe_variable instance for each
  # combination of workspace and environment variable,
  # so this one has a more complicated for_each expression.
  for_each = {
    for pair in setproduct(var.workspaces, keys(var.common_environment_variables)) : "${pair[0]}/${pair[1]}" => {
      workspace_name = pair[0]
      workspace_id   = tfe_workspace.workspace[pair[0]].id
      name           = pair[1]
      value          = var.common_environment_variables[pair[1]]
    }
  }

  workspace_id = each.value.workspace_id

  category  = "env"
  key       = each.value.name
  value     = each.value.value
  sensitive = true
}
