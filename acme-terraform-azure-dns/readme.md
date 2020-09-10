# Request Let's Encrypt certificates with Terraform and Azure DNS.

```
tf apply -auto-approve -var domain="*.stackmasters.com" -var azure_client_id=$ARM_CLIENT_ID -var azure_client_secret=$ARM_CLIENT_SECRET -var azure_subscription_id=$ARM_SUBSCRIPTION_ID -var azure_tenant_id=$ARM_TENANT_ID
```