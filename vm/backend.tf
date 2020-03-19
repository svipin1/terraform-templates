terraform {
  backend "remote" {
    organization = "cse"

    workspaces {
      name = "terraform-templates-vm"
    }
  }
}
