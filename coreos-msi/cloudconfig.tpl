#cloud-config
write_files:
  - path: "/tmp/terraformtest"
    permissions: "0644"
    owner: "root"
    content: |
      Created by Azure terraform by ${contact}
