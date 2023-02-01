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
      # http port mapping
      extra_port_mappings {
        container_port = 80
        host_port      = 9080
        listen_address = "0.0.0.0"
      }
      # ssl port mapping
      extra_port_mappings {
        container_port = 443
        host_port      = 9443
        listen_address = "0.0.0.0"
      }
      # localstack port
      extra_port_mappings {
        container_port = 31566
        host_port      = 4566
        listen_address = "0.0.0.0"
      }
      # ortelius nginx port
      extra_port_mappings {
        container_port = 31406
        host_port      = 31406
        listen_address = "0.0.0.0"
      }
      # ortelius nginx port
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

# ONLY ENABLE THIS IF YOU HAVE A LOCALSTACK PRO API KEY
#resource "kubectl_manifest" "localstack_apikey" {
#  yaml_body = <<YAML
#apiVersion: v1
#kind: Secret
#metadata:
#  name: localstack-apikey
#  namespace: localstack
#type: Opaque
#data:
#  localstack-apikey: ${base64encode(var.localstack_api_key)}
#YAML
#}

# ortelius https://artifacthub.io/packages/helm/ortelius/ortelius
# postgresql https://artifacthub.io/packages/helm/bitnami/postgresql-ha
resource "helm_release" "ortelius" {
  name             = "ortelius"
  chart            = "ortelius"
  repository       = "https://ortelius.github.io/ortelius-charts/"
  namespace        = var.ortelius_namespace
  create_namespace = true
  recreate_pods    = true
  depends_on       = [kind_cluster.ortelius]
}

# localstack https://docs.localstack.cloud/overview/
# localstack helm charts https://github.com/localstack/helm-charts
resource "helm_release" "localstack" {
  name             = "localstack"
  chart            = "localstack"
  repository       = "https://helm.localstack.cloud"
  namespace        = var.localstack_namespace
  create_namespace = true
  recreate_pods    = true
  depends_on       = [kind_cluster.ortelius]
  # ONLY ENABLE THIS IF YOU HAVE A LOCALSTACK PRO API KEY
  #values           = [file("localstack.yaml")]
}

resource "aws_s3_bucket" "ortelius_bucket" {
  bucket     = "ortelius-bucket"
  depends_on = [helm_release.localstack]
}
