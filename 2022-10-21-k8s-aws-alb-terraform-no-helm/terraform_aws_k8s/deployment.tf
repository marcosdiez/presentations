resource "kubernetes_deployment_v1" "terraform_deployment2" {

  metadata {
    name        = "terraform-deployment2"
    namespace   = local.namespace
    annotations = local.default_tags
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "terraform-deployment2"
      }
    }

    template {
      metadata {
        labels = {
          name = "terraform-deployment2"
        }
      }

      spec {
        container {
          name  = "terraform-deployment2"
          image = "gcr.io/kubernetes-e2e-test-images/echoserver:2.2"

          dynamic "env" {
            for_each = local.env
            content {
              name  = env.key
              value = env.value
            }
          }
        }
      }
    }
  }
}
