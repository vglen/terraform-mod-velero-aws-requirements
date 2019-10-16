## terraform-mod-velero-aws
```
module "velero" {
  source           = "git::ssh://git@github.com/vglen/terraform-mod-velero-aws-requirements.git//?ref=v1.0.0"
  cluster          = var.cluster
  product          = var.product
  env              = var.env
  region           = var.region
  ci_username      = var.ci_username
  account          = var.account
}
```
