variable "k8s_common_annotations" {
  default = {}
}

variable "k8s_deployment_name" {
  type = string
}

variable "k8s_namespace" {
  type = string
}

variable "container_listener_port" {
  type = string
}

variable "k8s_service_selector" {
  type = map(any)
}

resource "kubernetes_service_v1" "aws" {
  metadata {
    name        = var.k8s_deployment_name
    namespace   = var.k8s_namespace
    annotations = var.k8s_common_annotations
  }
  spec {
    selector = var.k8s_service_selector
    port {
      name        = "port${var.container_listener_port}"
      port        = var.container_listener_port
      target_port = var.container_listener_port
    }
    type = "NodePort"
  }
}


# https://kubernetes-sigs.github.io/aws-load-balancer-controller/v2.4/guide/targetgroupbinding/targetgroupbinding/

# apiVersion: elbv2.k8s.aws/v1beta1
# kind: TargetGroupBinding
# metadata:
#   name: my-tgb
# spec:
#   serviceRef:
#     name: awesome-service # route traffic to the awesome-service
#     port: 80
#   targetGroupARN: <arn-to-targetGroup>

resource "kubernetes_manifest" "TargetGroupBinding" {
  manifest = {
    apiVersion = "elbv2.k8s.aws/v1beta1"
    kind       = "TargetGroupBinding"

    metadata = {
      name        = var.k8s_deployment_name
      namespace   = var.k8s_namespace
      annotations = var.k8s_common_annotations
    }

    spec = {
      serviceRef = {
        name = kubernetes_service_v1.aws.metadata[0].name
        port = var.container_listener_port
      }
      targetGroupARN = aws_lb_target_group.k8s_tg.arn
    }
  }
}