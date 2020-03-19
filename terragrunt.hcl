remote_state {
  backend = "azure"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    resource_group_name  = "storage"
    storage_account_name = "tfme"
    container_name       = "tfstate"

    key = "${path_relative_to_include()}/terraform.tfstate"
  }
}
