resource "kubernetes_deployment_v1" "terraform_deployment" {

  metadata {
    name      = "terraform-deployment"
    namespace = "my-first-namespace"
  }

  spec {
    replicas = 1

    selector {
      match_labels = {
        name = "terraform-deployment"
      }
    }

    template {
      metadata {
        labels = {
          name = "terraform-deployment"
        }
      }

      spec {
        container {
          name  = "terraform-deployment"
          image = "gcr.io/kubernetes-e2e-test-images/echoserver:2.2"

          env {
            name  = "SAMPLE_ENV_NAME"
            value = "SAMPLE_ENV_VALUE"
          }
        }
      }
    }
  }
}

