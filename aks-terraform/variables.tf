################################
## Azure system configuration ##
################################

variable "location" {
  description = "Region"
  default     = "westeurope"
}

###############################
## AKS cluster configuration ##
###############################

variable "rg_name" {
  description = "Name of resource group for the AKS cluster. If empty cluster_name will be used instead."
  default     = ""
}

variable "deploy_aad" {
  description = "Whether to deploy AAD or not"
  default     = ""
}

variable "cluster_name" {
  description = "Name for this cluster"
}

variable "virtual_network_name" {
  description = "Virtual network name for AKS cluster"
  default     = "aks_vnet"
}

variable "virtual_network" {
  description = "Virtual network adress space for AKS cluster"
  default     = ["10.10.0.0/16"]
}

variable "subnet" {
  description = "Subnet adress space for AKS worker nodes"
  default     = "10.10.10.0/24"
}

variable "subnet_name" {
  description = "Subnet name for AKS worker nodes"
  default     = "agent_subnet"
}

variable "dns_prefix" {
  description = "DNS prefix specified when creating the managed cluster."
  default     = ""
}

#################################
## Kubernetes configuration ##
#################################

variable "kubernetes_version" {
  description = "Kubernetes version"
  default     = "1.10.3"
}

variable "max_pods" {
  description = "Max pods"
  default     = 30
}

variable "sp_client_id" {
  description = <<EOL
  Service Principal ID with permissions to manage resources in the target subscription
  Note: this should be defined as either an environment variable or an external var-file reference and not stored with the code base
EOL

  //  default = "00000000-0000-0000-0000-000000000000"
  # default = "please-configure-sp-details"
}

variable "sp_client_secret" {
  description = <<EOL
  Service Principal password with permissions to manage resources in the target subscription
  Note: this should be defined as either an environment variable or an external var-file reference and not stored with the code base
EOL

  # default = "000000000000000000000000000000000000000000000="
}

#################################
## Node / worker configuration ##
#################################

variable "agent_vm_sku" {
  description = "Azure VM SKU for the agent/worker nodes"
  default     = "Standard_DS2_v2"
}

variable "agentpool_name" {
  description = "agent pool name"
  default     = "agentpool"
}

variable "node_os_disk_size_gb" {
  description = "Size in GB of the node's OS disks (default 30)"
  default     = 30
}

variable "node_count" {
  description = "Number of worker nodes to create - defaults to 3"
  default     = 3
}

variable "agent_admin_user" {
  description = "Admin username for the first user created on the worker nodes"
  default     = "azureuser"
}

variable "public_key_data" {
  description = "Public SSH key to access the cluster nodes"
}

#################################
## RBAC configuration ##
#################################

variable "clientapp_id" {
  description = "Id of the client app for RBAC"
}

variable "tenant_id" {
  description = "tenant id"
}

variable "serverapp_secret" {
  description = "Password of the server app for RBAC"
}

variable "serverapp_id" {
  description = "Id of the server app for RBAC"
}

#################################
## Network configuration configuration ##
#################################

variable "dockerBridgeCidr" {
  description = "Kubernetes version"
  default     = "172.17.0.1/16"
}

variable "dnsServiceIP" {
  description = "Kubernetes version"
  default     = "10.0.0.10"
}

variable "serviceCidr" {
  description = "Kubernetes version"
  default     = "10.0.0.0/16"
}

variable "network_plugin" {
  description = "Kubernetes version"
  default     = "azure"
}
