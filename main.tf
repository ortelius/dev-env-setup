# kind https://kind.sigs.k8s.io/-
provider "kind" {
  # configuration options
}

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
      # ortelius http port
      extra_port_mappings {
        container_port = 50000
        host_port      = 8080
        listen_address = "0.0.0.0"
      }
#      # ortelius ssl port
#      extra_port_mappings {
#        container_port = 32089
#        host_port      = 443
#        listen_address = "0.0.0.0"
#      }
      # localstack port
      extra_port_mappings {
        container_port = 31566
        host_port      = 4566
        listen_address = "0.0.0.0"
      }
    }
    node {
      role = "worker"
    }
  }
}

# ONLY ENABLE THIS IF YOU HAVE A LOCALSTACK PRO API KEY
resource "kubectl_manifest" "localstack_apikey" {
  yaml_body = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: localstack-apikey
  namespace: localstack
type: Opaque
data:
  localstack-apikey: ${base64encode(var.localstack_api_key)}
YAML
}

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
  timeout          = 900
  dependency_update = true

  set {
    name  = "ms-nginx.ingress.nodePort"
    value = 50000
  }
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
  timeout          = 900
  # ONLY ENABLE THIS IF YOU HAVE A LOCALSTACK PRO API KEY
  values           = [file("localstack.yaml")]
}

resource "aws_s3_bucket" "ortelius_bucket" {
  bucket     = "ortelius-bucket"
  depends_on = [helm_release.localstack]
}

#resource "helm_release" "backstage" {
#  name             = "backstage"
#  chart            = "backstage"
#  repository       = "https://github.com/ortelius/backstage"
#  namespace        = var.backstage_namespace
#  create_namespace = true
#  recreate_pods    = true
#  depends_on       = [helm_release.ortelius]
#  timeout          = 900
  #values           = [file("service-nginx.yaml")]
#}
