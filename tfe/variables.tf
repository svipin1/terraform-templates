variable "workspaces" {
  type = set(string)
}

variable "common_environment_variables" {
  type = map(string)
}

variable "organization_name" {
  type = string
}
