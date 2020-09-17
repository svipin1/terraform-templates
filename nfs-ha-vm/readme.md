This template creates a single VM in Azure with X number of premium SSD managed disks, makes a RAID1(0) out of them, installs an NFS server on it and export the RAID as NFSv4 volume to the internal network.

It can be used with AKS and the [nfs-client-provisioner](https://github.com/kubernetes-incubator/external-storage/tree/master/nfs-client)

It needs to know the AKS vnet and its rg to peer with it

CIDR must not overlap

The template exports a yaml that can be simply applied to your cluster to use NFS immediately