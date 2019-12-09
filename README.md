# terraform-templates

```bash
tf init -backend-config="key=`basename $PWD`"
tf plan -var-file=`basename $PWD`.tfvars
tf apply -auto-approve
```

Testing GH actions