# fix to 1.24 https://medium.com/@nitinnbisht/annotation-in-helm-with-terraform-3fa04eb30b6e

provider   "kubernetes" {
    host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)

  }
  
provider "helm" {
  version = "1.2.4"
  kubernetes {
    host                   = azurerm_kubernetes_cluster.aks.kube_config.0.host
    client_key             = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_key)
    client_certificate     = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.client_certificate)
    cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks.kube_config.0.cluster_ca_certificate)

  }
}

resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress"
  }
    depends_on = [azurerm_kubernetes_cluster.aks]

}

resource "helm_release" "nginx-ingress" {
  name       = "nginx-ingress"
  chart      = "stable/nginx-ingress"
  namespace  = "ingress"
  
  #because of inconsisten behaviour on Network Contributor role propagation of the identity[0].principal_id on the subnet, helm will fail. We can increase the timeout or set wait=false
  timeout = 1000
  depends_on = [kubernetes_namespace.ingress]

  set {
    name  = "controller.service.annotations.service\\.beta\\.kubernetes\\.io/azure-load-balancer-internal"
    value = "true"
    type  = "string"
  }
}
