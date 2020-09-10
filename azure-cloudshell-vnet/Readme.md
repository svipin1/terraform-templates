# Deploy Azure Cloud Shell in a private VNET

Inspired by https://docs.microsoft.com/en-us/azure/cloud-shell/private-vnet

- Imports an existing RG+VNET
- Creates a Storage Account in $RG
- Deploys 3 subnets (CloudShell container, Relay and Storage)
- Creates


## Prereqs

Only in WestCentralUS/WestUS !!

```bash
RG=aksrg
REGION=westcentralus
#Create a RG
az group create -n $RG --location $REGION

#Create a VNET and a subnet
az network vnet create -g $RG -n aksvnet --address-prefixes 172.20.0.0/16 --location $REGION
az network vnet subnet create -g $RG --vnet-name aksvnet --address-prefixes 172.20.100.0/24 -n akssubnet

# Create an AKS cluster in the subnet
az aks create -g $RG -l $REGION -c 1 -n aks --vnet-subnet-id /subscriptions/12c7e9d6-967e-40c8-8b3e-4659a4ada3ef/resourceGroups/$RG/providers/Microsoft.Network/virtualNetworks/aksvnet/subnets/akssubnet

# Get credential for the cluster
az aks get-credentials -g $RG -n aks

# get node IP
kubectl get node -o wide

# deploy the tera