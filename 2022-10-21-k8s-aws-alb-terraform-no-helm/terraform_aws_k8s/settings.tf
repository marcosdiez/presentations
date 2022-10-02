
provider "kubernetes" {
  # aws sts get-caller-identity
  # mkdir -p ~/.kube; aws eks update-kubeconfig --name mycluster --kubeconfig "~/.kube/config.mycluster.yaml"
  config_path = "~/.kube/config.mycluster.yaml"
}


provider "aws" {
  region = "us-east-1"
  default_tags {
    tags = local.default_tags
  }
}


locals {
  hostname  = "mdieztest77.collateral360.com"
  namespace = "my-first-namespace"

  aws_alb_name    = "XXXXXXXXXX"
  route53_zone_id = "YYYYYYY"

  default_tags = {
    creator   = "marcosdiez"
    terraform = "https://github.com/marcosdiez/presentations/terraform_aws_k8s"
    dashboard = "https://url-to-k8s-dashboard.com/"
    url       = "https://${local.hostname}"
  }

  env = {
    "ENV1" = "VALUE1",
    "ENV2" = "VALUE2",
    "ENV3" = "VALUE3",
  }

}