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
      role                   = "control-plane"
      kubeadm_config_patches = ["kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"kubernetes.io/os=linux\"\n"]

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
      # localhost run proxy
      extra_port_mappings {
        container_port = 32042
        host_port      = 32042
        listen_address = "0.0.0.0"
      }
      # Hubble relay
      extra_port_mappings {
        container_port = 31234
        host_port      = 31234
        listen_address = "0.0.0.0"
      }
      # Hubble UI
      extra_port_mappings {
        container_port = 31235
        host_port      = 31235
        listen_address = "0.0.0.0"
      }
      node {
        role = "worker"
        # postgres persistent volume
        extra_mounts {
          host_path      = "/tmp/postgres"
          container_path = "/pgdata"
        }
        # cilium
        extra_mounts {
          host_path      = "/opt/images"
          container_path = "/opt/images"
        }
        # cilium
        networking {
          disable_default_cni = "true"
        }
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

# cilium
# https://artifacthub.io/packages/helm/cilium/cilium
resource "helm_release" "cilium" {
  name              = "cilium"
  chart             = "cilium"
  repository        = "https://github.com/cilium/cilium"
  create_namespace  = false
  recreate_pods     = true
  depends_on        = [kind_cluster.ortelius]
  timeout           = 900
  dependency_update = true
  replace           = true

  # cluster id
  set {
    name  = "cluster.id"
    value = "0"
  }
  # cluster name
  set {
    name  = "name"
    value = "kind-ortelius"
  }
  # node encryption
  set {
    name  = "encryption.nodeEncryption"
    value = "false"
  }
  # ipam mode
  set {
    name  = "ipam.mode"
    value = "kubernetes"
  }
  # kube proxy replacement
  set {
    name  = "kubeProxyReplacement"
    value = "disabled"
  }
  # operator
  set {
    name  = "operator.replicas"
    value = "1"
  }
  # service accounts cilium
  set {
    name  = "serviceAccounts.cilium.name"
    value = "cilium"
  }
  # service accounts operator
  set {
    name  = "serviceAccounts.operator.name"
    value = "cilium-operator"
  }
  # tunnel
  set {
    name  = "tunnel"
    value = "vxlan"
  }
}
