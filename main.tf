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
        container_port = 31000
        host_port      = 8080
        listen_address = "0.0.0.0"
      }
      # postgresql port
      extra_port_mappings {
        container_port = 31316
        host_port      = 5432
        listen_address = "0.0.0.0"
      }
      # postgres persistent volume
      extra_mounts {
        host_path      = "/Users/tvl/Documents/postgres"
        container_path = "/pgdata"
      }
    }
    node {
      role = "worker"
      # postgres persistent volume
      extra_mounts {
        host_path      = "/Users/tvl/Documents/postgres"
        container_path = "/pgdata"
      }
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
  # global ingress nginx controller
  set {
    name  = "global.ingress.nginx.controller"
    value = "true"
  }
  # node port for ui access from localhost
  set {
    name  = "ms-nginx.ingress.nodePort"
    value = "31000"
  }
  # postgres global
  set {
    name  = "global.postgresql.enabled"
    value = "true"
  }
  # node port for postgres access from localhost
  set {
    name  = "ms-postgres.ingress.nodePort"
    value = "31316"
  }
  # postgres password
  set {
    name  = "ms-general.dbpass"
    value = "postgres"
  }
}