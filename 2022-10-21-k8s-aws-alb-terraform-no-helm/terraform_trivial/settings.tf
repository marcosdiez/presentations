provider "kubernetes" {
  # aws sts get-caller-identity
  # mkdir -p ~/.kube; aws eks update-kubeconfig --name mycluster --kubeconfig "~/.kube/config.mycluster.yaml"
  config_path = "~/.kube/config.mycluster.yaml"
}

