#Terraformed, loadbalanced SFTP service

This folder contains a Terraform template to deploy 2 CentOS VM, each connected to a pre-existing Azure File Storage, fronted by an Azure LoadBalancer to act as an highly-available SFTP server.
To use, copy the `terraform.tfvarsexample` to `terraform.tfvar` and fill the variables.
The Standard LoadBalancer uses session persistence (`load_distribution = "SourceIP"`).
