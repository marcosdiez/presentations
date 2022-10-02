/*
    beware that some resources need to be terraform tainted depending on the change:

    as of 2022-10-01, this can't yet be automatic:
    https://github.com/hashicorp/terraform-provider-kubernetes/issues/1518

    module.sample_aws_k8s_integration.aws_lb_listener_rule.k8s_rule
    module.sample_aws_k8s_integration.kubernetes_manifest.TargetGroupBinding

*/

module "sample_aws_k8s_integration" {
  source = "./modules/awsk8salb"

  k8s_common_annotations = local.default_tags
  k8s_deployment_name    = kubernetes_deployment_v1.terraform_deployment2.metadata[0].name
  k8s_namespace          = kubernetes_deployment_v1.terraform_deployment2.metadata[0].namespace
  k8s_service_selector   = kubernetes_deployment_v1.terraform_deployment2.spec[0].selector[0].match_labels

  container_listener_port = 8080

  aws_lb_name     = local.aws_alb_name
  hostname        = local.hostname
  route53_zone_id = local.route53_zone_id

}

output "sample_aws_k8s_integration" {
  value = module.sample_aws_k8s_integration
}
