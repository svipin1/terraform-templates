This template will create an app gateway in one region, two AKS cluster in 2 different regions (with peered vnets); deploy nginx ingress controller on each cluster with ILB service; map the ILB IP to a private DNS zone A record, add those records to the backend pool of the AppGw. This way, the Appgw will effectively loadbalance an app deployed on multiple clustes in multiple regions over a single frontend IP.

TODO:

- Zonal frontend IP
- SSL certificate termination at the AppGw
- Interpolate region in fqdn backend
