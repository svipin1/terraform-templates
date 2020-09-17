resource "random_id" "instance_id" {
  byte_length = 3
}

resource "rancher2_cluster" "aks" {
  name        = var.cluster_name
  description = "Made by Terraform"

  aks_config {
    master_dns_prefix = "aksrancher"
    agent_dns_prefix  = "dns"
    client_id         = var.az_client_id
    client_secret     = var.az_client_secret
    subscription_id   = var.az_subscription_id
    tenant_id         = var.az_tenant_id

    agent_pool_type = "VirtualMachineScaleSets"

    resource_group = var.az_resource_group
    location       = var.location

    kubernetes_version      = var.kubernetes_version
    admin_username          = var.admin_username
    ssh_public_key_contents = var.ssh_key
    agent_vm_size           = var.agent_vm_size
    agent_os_disk_size      = var.agent_os_disk_size
    agent_pool_name         = var.agent_pool_name
    count                   = var.node_count
    enable_monitoring       = var.enable_monitoring

    max_pods       = var.max_pods
    network_plugin = var.network_plugin

    virtual_network_resource_group = var.az_resource_group
    virtual_network                = var.az_vnet
    subnet                         = var.az_subnet

  }
}
