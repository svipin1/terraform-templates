variable "resource_group_name" {
  description = "resource_group_name"
  default     = ""
}

variable "vnet_name" {
  description = "vnet_name"
  default     = ""
}

variable "cloudshell_subnet_prefix" {
  description = "cloudshell_subnet_prefix"
  default     = ""
}

variable "relay_subnet_prefix" {
  description = "cloudshell_subnet_prefix"
  default     = ""
}

variable "storage_subnet_prefix" {
  description = "cloudshell_subnet_prefix"
  default     = ""
}

variable "container_istance_objid" {
  description = "container_istance_objid"
  default     = "Obtained by Get-AzADServicePrincipal -DisplayNameBeginsWith 'Azure Container Instance'"
}

variable "networkRoleDefinitionId" {
  description = "networkRoleDefinitionId"
  default     = "hardcoded"
}

variable "contributorRoleDefinitionId" {
  description = "contributorRoleDefinitionId"
  default     = "hardcoded"
}