# localstack use|
# use the tflocal terraform wrapper for the terraform deployment &
# https://docs.localstack.cloud/user-guide/integrations/terraform/
# awscli-local wrapper for using aws localstack endpoints
# awscli-local | https://docs.localstack.cloud/user-guide/integrations/aws-cli/
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
        container_port = 30000
        host_port      = 8080
        listen_address = "0.0.0.0"
      }
      # postgresql port
      extra_port_mappings {
        container_port = 30001
        host_port      = 5432
        listen_address = "0.0.0.0"
      }
      # localstack port
      extra_port_mappings {
        container_port = 34566
        host_port      = 4566
        listen_address = "0.0.0.0"
      }
    }
    node {
      role = "worker"
    }
  }
}

# ortelius
# https://artifacthub.io/packages/helm/ortelius/ortelius
resource "helm_release" "ortelius" {
  name              = "ortelius"
  chart             = "ortelius"
  repository        = "https://ortelius.github.io/ortelius-charts/"
  namespace         = var.ortelius_namespace
  create_namespace  = true
  recreate_pods     = true
  depends_on        = [kind_cluster.ortelius]
  timeout           = 900
  dependency_update = true
  replace           = true

  # postgres node port for database access from localhost
  set {
    name  = "ms-postgres.nodePort"
    value = "30001"
  }
  # postgres password
  set {
    name  = "ms-general.dbpass"
    value = "postgres"
  }
  # postgres global
  set {
    name  = "global.postgresql.enabled"
    value = "true"
  }
  # global ingress nginx controller
  set {
    name  = "global.ingress.nginx.controller"
    value = "true"
  }
  # node port for ui access from localhost
  set {
    name  = "ms-nginx.ingress.nodePort"
    value = "30000"
  }
}

# ONLY ENABLE THIS IF YOU HAVE A LOCALSTACK PRO API KEY
resource "kubectl_manifest" "localstack_apikey" {
  depends_on = [helm_release.ortelius]
  apply_only = true
  yaml_body  = <<YAML
apiVersion: v1
kind: Secret
metadata:
  name: localstack-apikey
  namespace: ortelius
type: Opaque
data:
  localstack-apikey: ${base64encode(var.localstack_api_key)}
YAML
}

# localstack https://docs.localstack.cloud/overview/
# localstack helm charts https://github.com/localstack/helm-charts
resource "helm_release" "localstack" {
  name       = "localstack"
  chart      = "localstack"
  repository = "https://helm.localstack.cloud"
  namespace  = var.localstack_namespace
  #namespace = var.ortelius_namespace
  create_namespace = true
  recreate_pods    = true
  depends_on       = [helm_release.ortelius]
  timeout          = 900
  # ONLY ENABLE THIS IF YOU HAVE A LOCALSTACK PRO API KEY
  values = [file("localstack.yaml")]
}
# creates an S3 bucket called ortelius
# accessible at http://s3.local.gd:4566/ortelius-bucket
resource "aws_s3_bucket" "ortelius-bucket" {
  bucket     = "ortelius-bucket"
  depends_on = [helm_release.localstack]
}
