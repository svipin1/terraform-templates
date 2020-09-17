# Create an AKS cluster in a private VNET and a jump host

Based on https://stackoverflow.com/questions/60361124/terraform-connect-to-aks-cluster-without-running-az-login/60364346#60364346



```
tf output ssh_private_key > ~/.ssh/temp
tf output ssh_public_key > ~/.ssh/temp.pub
chmod 0600 ~/.ssh/temp

ssh -i ~/.ssh/temp ubuntu@$(tf output azurerm_public_ip) kubectl get nodes
```