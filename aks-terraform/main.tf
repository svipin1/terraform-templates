resource "azurerm_resource_group" "aks_rg" {
  location = "${var.location}"
  name     = "${var.rg_name == "" ? var.cluster_name : var.rg_name}"
}

resource "azurerm_virtual_network" "aks_vnet" {
  name                = "${var.virtual_network_name}"
  address_space       = "${var.virtual_network}"
  location            = "${azurerm_resource_group.aks_rg.location}"
  resource_group_name = "${azurerm_resource_group.aks_rg.name}"
}

resource "azurerm_subnet" "aks_subnet" {
  name                 = "${var.subnet_name}"
  virtual_network_name = "${azurerm_virtual_network.aks_vnet.name}"
  address_prefix       = "${var.subnet}"
  resource_group_name  = "${var.rg_name}"
}

resource "azurerm_template_deployment" "aks-aad" {
  count = "${var.deploy_aad != "" ? 1 : 0}"

  name                = "aksdeployment"
  resource_group_name = "${azurerm_resource_group.aks_rg.name}"

  # these key-value pairs are passed into the ARM Template's `parameters` block
  parameters {
    "public_key_data"      = "${var.public_key_data}"
    "agent_admin_user"     = "${var.agent_admin_user}"
    "node_os_disk_size_gb" = "${var.node_os_disk_size_gb}"
    "node_count"           = "${var.node_count}"
    "vnet_subid"           = "${azurerm_subnet.aks_subnet.id}"
    "max_pods"             = "${var.max_pods}"
    "network_plugin"       = "${var.network_plugin}"
    "serviceCidr"          = "${var.serviceCidr}"
    "dnsServiceIP"         = "${var.dnsServiceIP}"
    "dockerBridgeCidr"     = "${var.dockerBridgeCidr}"
    "agent_vm_sku"         = "${var.agent_vm_sku}"
    "agentpool_name"       = "${var.agentpool_name}"
    "dns_prefix"           = "${var.dns_prefix}"
    "kubernetes_version"   = "${var.kubernetes_version}"
    "cluster_name"         = "${var.cluster_name}"
    "clientapp_id"         = "${var.clientapp_id}"
    "tenant_id"            = "${var.tenant_id}"
    "serverapp_secret"     = "${var.serverapp_secret}"
    "serverapp_id"         = "${var.serverapp_id}"
    "sp_client_id"         = "${var.sp_client_id}"
    "sp_client_secret"     = "${var.sp_client_secret}"
    "location"             = "${var.location}"
  }

  deployment_mode = "Incremental"

  template_body = <<DEPLOY
{  
    "$schema":"https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion":"1.0.0.0",
    "parameters":{  
       "public_key_data":{  
          "type":"string"
       },
       "agent_admin_user":{  
          "type":"string"
       },
       "node_os_disk_size_gb":{  
          "type": "string",
          "defaultValue": 0
       },
       "node_count":{  
        "type": "string",
        "defaultValue": 3
       },
       "vnet_subid":{  
          "type":"string"
       },
       "max_pods":{  
          "type":"string"
       },
       "network_plugin":{  
          "type":"string"
       },
       "serviceCidr":{  
        "type": "string"
       },
       "dnsServiceIP":{  
          "type":"string"
       },
       "dockerBridgeCidr":{  
          "type":"string"
       },
       "agent_vm_sku":{  
          "type":"string"
       },
       "agentpool_name":{  
          "type":"string"
       },
       "dns_prefix":{  
          "type":"string"
       },
       "kubernetes_version":{  
          "type":"string"
       },
       "cluster_name":{  
          "type":"string"
       },
       "clientapp_id":{  
          "type":"string"
       },
       "serverapp_id":{  
          "type":"string"
       },
       "serverapp_secret":{  
          "type":"string"
       },
       "tenant_id":{  
          "type":"string"
       },
       "sp_client_secret":{  
          "type":"string"
       },
       "sp_client_id":{  
          "type":"string"
       },
       "location":{  
          "type":"string",
          "defaultValue":"[resourceGroup().location]",
          "metadata":{  
             "description":"Location for all resources."
          }
       }
    },
    "resources":[  
       {  
          "name":"[parameters('cluster_name')]",
          "type":"Microsoft.ContainerService/managedClusters",
          "apiVersion":"2018-03-31",
          "location":"[parameters('location')]",
          "tags":{  
 
          },
          "properties":{  
             "kubernetesVersion":"[parameters('kubernetes_version')]",
             "dnsPrefix":"[parameters('dns_prefix')]",
             "agentPoolProfiles":[  
                {  
                   "name": "agentpool",
                   "count":"[int(parameters('node_count'))]",
                   "vmSize":"[parameters('agent_vm_sku')]",
                   "osDiskSizeGB":"[int(parameters('node_os_disk_size_gb'))]",
                   "vnetSubnetID":"[parameters('vnet_subid')]",
                   "maxPods":"[int(parameters('max_pods'))]",
                   "osType":"Linux",
                   "storageProfile": "ManagedDisks"
                }
             ],
             "linuxProfile":{  
                "adminUsername":"[parameters('agent_admin_user')]",
                "ssh":{  
                   "publicKeys":[  
                      {  
                         "keyData":"[parameters('public_key_data')]"
                      }
                   ]
                }
             },
             "servicePrincipalProfile":{  
                "clientId":"[parameters('sp_client_id')]",
                "secret":"[parameters('sp_client_secret')]"
             },
             "addonProfiles":{  
 
             },
             "enableRBAC":true,
             "networkProfile":{  
                "networkPlugin":"[parameters('network_plugin')]",
                "serviceCidr":"[parameters('serviceCidr')]",
                "dnsServiceIP":"[parameters('dnsServiceIP')]",
                "dockerBridgeCidr":"[parameters('dockerBridgeCidr')]"
             },
             "aadProfile":{  
                "clientAppID":"[parameters('clientapp_id')]",
                "serverAppID":"[parameters('serverapp_id')]",
                "serverAppSecret":"[parameters('serverapp_secret')]",
                "tenantID":"[parameters('tenant_id')]"
             }
          }
       }
    ]
 }
    DEPLOY
}

resource "azurerm_template_deployment" "aks-noaad" {
  count = "${var.deploy_aad != "" ? 0 : 1}"

  name                = "aksdeployment"
  resource_group_name = "${azurerm_resource_group.aks_rg.name}"

  # these key-value pairs are passed into the ARM Template's `parameters` block
  parameters {
    "public_key_data"      = "${var.public_key_data}"
    "agent_admin_user"     = "${var.agent_admin_user}"
    "node_os_disk_size_gb" = "${var.node_os_disk_size_gb}"
    "node_count"           = "${var.node_count}"
    "vnet_subid"           = "${azurerm_subnet.aks_subnet.id}"
    "max_pods"             = "${var.max_pods}"
    "network_plugin"       = "${var.network_plugin}"
    "serviceCidr"          = "${var.serviceCidr}"
    "dnsServiceIP"         = "${var.dnsServiceIP}"
    "dockerBridgeCidr"     = "${var.dockerBridgeCidr}"
    "agent_vm_sku"         = "${var.agent_vm_sku}"
    "agentpool_name"       = "${var.agentpool_name}"
    "dns_prefix"           = "${var.dns_prefix}"
    "kubernetes_version"   = "${var.kubernetes_version}"
    "cluster_name"         = "${var.cluster_name}"
    "clientapp_id"         = "${var.clientapp_id}"
    "tenant_id"            = "${var.tenant_id}"
    "location"             = "${var.location}"
  }

  deployment_mode = "Incremental"

  template_body = <<DEPLOY
{  
    "$schema":"https://schema.management.azure.com/schemas/2015-01-01/deploymentTemplate.json#",
    "contentVersion":"1.0.0.0",
    "parameters":{  
       "public_key_data":{  
          "type":"string"
       },
       "agent_admin_user":{  
          "type":"string"
       },
       "node_os_disk_size_gb":{  
          "type": "string",
          "defaultValue": 0
       },
       "node_count":{  
        "type": "string",
        "defaultValue": 3
       },
       "vnet_subid":{  
          "type":"string"
       },
       "max_pods":{  
          "type":"string"
       },
       "network_plugin":{  
          "type":"string"
       },
       "serviceCidr":{  
        "type": "string"
       },
       "dnsServiceIP":{  
          "type":"string"
       },
       "dockerBridgeCidr":{  
          "type":"string"
       },
       "agent_vm_sku":{  
          "type":"string"
       },
       "agentpool_name":{  
          "type":"string"
       },
       "dns_prefix":{  
          "type":"string"
       },
       "kubernetes_version":{  
          "type":"string"
       },
       "cluster_name":{  
          "type":"string"
       },
       "clientapp_id":{  
          "type":"string"
       },
       "serverapp_id":{  
          "type":"string"
       },
       "serverapp_secret":{  
          "type":"string"
       },
       "tenant_id":{  
          "type":"string"
       },
       "sp_client_secret":{  
          "type":"string"
       },
       "sp_client_id":{  
          "type":"string"
       },
       "location":{  
          "type":"string",
          "defaultValue":"[resourceGroup().location]",
          "metadata":{  
             "description":"Location for all resources."
          }
       }
    },
    "resources":[  
       {  
          "name":"[parameters('cluster_name')]",
          "type":"Microsoft.ContainerService/managedClusters",
          "apiVersion":"2018-03-31",
          "location":"[parameters('location')]",
          "tags":{  
 
          },
          "properties":{  
             "kubernetesVersion":"[parameters('kubernetes_version')]",
             "dnsPrefix":"[parameters('dns_prefix')]",
             "agentPoolProfiles":[  
                {  
                   "name": "agentpool",
                   "count":"[int(parameters('node_count'))]",
                   "vmSize":"[parameters('agent_vm_sku')]",
                   "osDiskSizeGB":"[int(parameters('node_os_disk_size_gb'))]",
                   "vnetSubnetID":"[parameters('vnet_subid')]",
                   "maxPods":"[int(parameters('max_pods'))]",
                   "osType":"Linux",
                   "storageProfile": "ManagedDisks"
                }
             ],
             "linuxProfile":{  
                "adminUsername":"[parameters('agent_admin_user')]",
                "ssh":{  
                   "publicKeys":[  
                      {  
                         "keyData":"[parameters('public_key_data')]"
                      }
                   ]
                }
             },
             "servicePrincipalProfile":{  
                "clientId":"[parameters('sp_client_id')]",
                "secret":"[parameters('sp_client_secret')]"
             },
             "addonProfiles":{  
 
             },
             "enableRBAC":true,
             "networkProfile":{  
                "networkPlugin":"[parameters('network_plugin')]",
                "serviceCidr":"[parameters('serviceCidr')]",
                "dnsServiceIP":"[parameters('dnsServiceIP')]",
                "dockerBridgeCidr":"[parameters('dockerBridgeCidr')]"
             }
          }
       }
    ]
 }
    DEPLOY
}
