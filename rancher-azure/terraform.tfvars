cluster_name       = "aks"
kubernetes_version = "1.18.8"
az_resource_group  = "rancheraks"
az_subnet          = "ranchersubet"
az_vnet            = "ranchervnet"
admin_username     = "rancher"
ssh_key            = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIOxg+goSYoCIND3IIAjPoPGr7gsux9OQjE5IP2wEU8eMsywgGXBwZXUVjh8NgFHVWZEMTQCAM52P2ipYBup9QhuqWVjH4v0hrj1X/rx7tzlZh2wk3kgVPQwMKCyacQLifqus4quJLSQAPu1ksgxaWEBWnSa0e+DM2D0PYs/j284qOO9T9ULqpb/ZJK9gySa+AfSMhGCskcT/EfE8g1iqC96PajFxGHOBxqiDFtIKPhNiqKYruDhVJYmhAXG6ScHadiXzP3BdiPR66eyCOQtSeIxjnEeJcrZ7vZLFpWQvaaZw+JfPkGGFCsBTn39dfr1awrMtPIPvkj4iU1jkGKzUD alessandro@Alessandros-MBP.fritz.box"
agent_vm_size      = "Standard_B4ms"
agent_os_disk_size = "30"
agent_pool_name    = "rancher"
node_count         = "2"
enable_monitoring  = false
location           = "West US"
max_pods           = "110"
network_plugin     = "kubenet"