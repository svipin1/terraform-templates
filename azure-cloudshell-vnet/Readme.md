# Deploy Azure Cloud Shell in a private VNET

Inspired by https://docs.microsoft.com/en-us/azure/cloud-shell/private-vnet

- Imports an existing RG+VNET
- Deploys 3 subnets (CloudShell container, Relay and Storage)