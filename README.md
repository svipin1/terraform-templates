# Terraform templates

```
 git clone --recurse-submodules https://github.com/ams0/terraform-templates.git
```

```bash
tf init -backend-config="key=`basename $PWD`"
tf plan -var-file=`basename $PWD`.tfvars
tf apply -auto-approve
```

Results:

[<img src="https://github.com/ams0/terraform-templates/workflows/TFApplyVM/badge.svg">](https://github.com/ams0/terraform-templates/actions?query=workflow%3ATFApplyVM)

