resource "random_id" "instance_id" {
 byte_length = 3
}

resource "rancher2_cluster" "cluster_az" {
  name         = "aks-${random_id.instance_id.hex}"
  description  = "Terraform"

  aks_config {
    agent_dns_prefix = "agent-${random_id.instance_id.hex}"
    master_dns_prefix = "aks-${random_id.instance_id.hex}"
    client_id = var.az-client-id
    client_secret = var.az-client-secret
    subscription_id = var.az-subscription-id
    tenant_id = var.az-tenant-id
    kubernetes_version = var.k8version
    resource_group = var.az-resource-group
    virtual_network_resource_group = var.az-resource-group
    subnet = var.az-subnet
    virtual_network = var.az-vnet
    admin_username = "rancher"
    ssh_public_key_contents = file("~/.ssh/id_rsa.pub")
    agent_vm_size = var.type
    agent_os_disk_size = var.disksize
    agent_pool_name = "rancher0"
    count = var.numnodes
    enable_monitoring = false
    location = var.az-region
    max_pods = 70
    network_plugin = var.az-plugin
  }
}
