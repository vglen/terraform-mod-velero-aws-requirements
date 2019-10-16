variable "account" {}
variable "ci_username" {
  description = "The IAM user that your CI uses"
}

variable "cluster" {
  description = "The name of the associated kubernetes cluster"
}

variable "env" {
  description = "Cluster environment. i.e. dev, qa, prod, lower"
}
variable "product" {
  default = "velero"
}
variable "region" {
  description = "AWS Region. i.e us-east-2"
}
