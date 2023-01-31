# kind https://kind.sigs.k8s.io/-
provider "kind" {}

resource "kind_cluster" "ortelius" {
  name            = var.kind_cluster_name
  node_image      = "kindest/node:v1.25.3"
  kubeconfig_path = pathexpand(var.kind_cluster_config_path)
  wait_for_ready  = true

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      kubeadm_config_patches = [
        "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"kubernetes.io/os=linux\"\n"
      ]

      extra_port_mappings {
        container_port = 80
        host_port      = 80
        listen_address = "0.0.0.0"
      }
      extra_port_mappings {
        container_port = 443
        host_port      = 443
        listen_address = "0.0.0.0"
      }
      # hardcoded port comes from the localstack helm chart values.yaml
      extra_port_mappings {
        container_port = 31566
        host_port      = 31566
        listen_address = "0.0.0.0"
      }
      extra_port_mappings {
        container_port = 31406
        host_port      = 31406
        listen_address = "0.0.0.0"
      }
      extra_port_mappings {
        container_port = 31804
        host_port      = 31804
        listen_address = "0.0.0.0"
      }
    }

    node {
      role = "worker"
    }
  }
}

# nginx ingress controller maintained by the K8s community https://github.com/kubernetes/ingress-nginx/
resource "helm_release" "ingress_nginx" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  namespace        = var.ingress_nginx_namespace
  create_namespace = true
  depends_on       = [kind_cluster.ortelius]
  timeout          = 600

  values = [file("ingress-nginx/values.yaml")]
}

resource "null_resource" "wait_for_ingress_nginx" {
  triggers = {
    key = uuid()
  }

  provisioner "local-exec" {
    command = <<EOF
      printf "\nWaiting for the nginx ingress controller...\n"
      kubectl wait --namespace ${helm_release.ingress_nginx.namespace} \
        --for=condition=ready pod \
        --selector=app.kubernetes.io/component=controller \
        --timeout=180s
    EOF
  }
  depends_on = [helm_release.ingress_nginx]
}

# ortelius https://artifacthub.io/packages/helm/ortelius/ortelius
# postgresql https://artifacthub.io/packages/helm/bitnami/postgresql-ha
resource "helm_release" "ortelius" {
  name             = "ortelius"
  chart            = "ortelius"
  repository       = "https://ortelius.github.io/ortelius-charts/"
  namespace        = var.ortelius_namespace
  create_namespace = true
  depends_on       = [kind_cluster.ortelius]
  timeout          = 600
}

# localstack https://docs.localstack.cloud/overview/
# localstack helm charts https://github.com/localstack/helm-charts
resource "helm_release" "localstack" {
  name             = "localstack"
  chart            = "localstack"
  repository       = "https://helm.localstack.cloud"
  namespace        = var.localstack_namespace
  create_namespace = true
  depends_on       = [kind_cluster.ortelius]
  #timeout          = 600
}

resource "aws_s3_bucket" "ortelius_bucket" {
  bucket = "ortelius-bucket"
}
