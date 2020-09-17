variable "rancher_url" {}
variable "rancher_token" {}

variable "cluster_name" {}

variable "master_dns_prefix" {}
variable "agent_dns_prefix" {}

variable "az_client_id" {}
variable "az_client_secret" {}
variable "az_subscription_id" {}
variable "az_tenant_id" {}

variable "kubernetes_version" {}
variable "az_resource_group" {}
variable "az_subnet" {}
variable "az_vnet" {}
variable "ssh_key" {}
variable "agent_vm_size" {}
variable "agent_pool_name" {}
variable "agent_os_disk_size" {}
variable "admin_username" {}
variable "node_count" {}
variable "enable_monitoring" {}
variable "location" {}
variable "max_pods" {}
variable "network_plugin" {}