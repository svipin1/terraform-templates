terraform {
  backend "remote" {
    organization = "cse"

    workspaces {
      name = "terraform-templates-aks-arm"
    }
  }
}