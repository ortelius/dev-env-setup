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
    }

    node {
      role = "worker"
    }
  }
}

provider "kubectl" {
  apply_retry_count      = 15
  host                   = kind_cluster.ortelius.endpoint
  cluster_ca_certificate = kind_cluster.ortelius.cluster_ca_certificate
  client_certificate     = kind_cluster.ortelius.client_certificate
  client_key             = kind_cluster.ortelius.client_key
  load_config_file       = false

  data "kubectl_filename_list" "manifests" {
    pattern = "./bird_router/*.yaml"
  }

  resource "kubectl_manifest" "bird_router" {
    count     = length(data.kubectl_filename_list.manifests.matches)
    yaml_body = file(element(data.kubectl_filename_list.manifests.matches, count.index))
  }

}

provider "helm" {
  debug = true
  kubernetes {
    host                   = kind_cluster.ortelius.endpoint
    cluster_ca_certificate = kind_cluster.ortelius.cluster_ca_certificate
    client_certificate     = kind_cluster.ortelius.client_certificate
    client_key             = kind_cluster.ortelius.client_key
    config_path            = pathexpand(var.kind_cluster_config_path)
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

# purelb loadbalancer https://gitlab.com/api/v4/projects/20400619/packages/helm/stable
# https://purelb.gitlab.io/docs/
resource "helm_release" "purelb" {
  name             = "purelb"
  repository       = "https://gitlab.com/api/v4/projects/20400619/packages/helm/stable"
  chart            = "purelb"
  namespace        = var.purelb_namespace
  create_namespace = true
  depends_on       = [kind_cluster.ortelius]
  #timeout          = 600

  #values = [file("purelb/values.yaml")]
}

# ortelius https://artifacthub.io/packages/helm/ortelius/ortelius
# postgresql https://artifacthub.io/packages/helm/bitnami/postgresql-ha
resource "helm_release" "ortelius" {
  name             = "ortelius"
  chart            = "ortelius"
  repository       = "https://ortelius.github.io/ortelius-charts/"
  namespace        = "ortelius"
  create_namespace = true
  depends_on       = [kind_cluster.ortelius]
  timeout          = 600
}

# arangodb https://www.arangodb.com/ https://github.com/arangodb/kube-arangodb
#resource "helm_release" "kube_arangodb" {
#  name             = "arangodb"
#  chart            = "./arangodb/kube-arangodb"
#  namespace        = "arangodb"
#  create_namespace = true
#  depends_on       = [kind_cluster.ortelius]
#  timeout = 600
#
#  values = [
#    file("arangodb/kube-arangodb/values.yaml"),
#  ]
#}

# keptn lifecycle toolkit https://github.com/keptn/lifecycle-toolkit
#resource "null_resource" "keptn" {
#
#  provisioner "local-exec" {
#    command = <<EOF
#      kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.10.0/cert-manager.yaml
#      sleep 45
#      kubectl apply -f https://github.com/keptn/lifecycle-toolkit/releases/download/v0.4.0/manifest.yaml
#    EOF
#  }
#  depends_on = [kind_cluster.ortelius]
#}

## argocd https://argoproj.github.io/argo-helm/
#resource "helm_release" "argocd" {
#  name             = "argocd"
#  chart            = "argo-cd"
#  namespace        = "argocd"
#  create_namespace = true
#  depends_on       = [kind_cluster.ortelius]
#  timeout = 600
#
#  values = [
#    file("argo-cd/values.yaml"),
#  ]
#}

# kubescape K8s cluster & image security https://kubescape.github.io/helm-charts/
# https://github.com/kubescape/kubescape
#resource "helm_release" "kubescape" {
#  name             = "kubescape"
#  chart            = "kubescape-cloud-operator"
#  repository       = "https://kubescape.github.io/helm-charts/"
#  namespace        = "kubescape"
#  create_namespace = true
#  depends_on       = [kind_cluster.ortelius]
#  timeout = 600
#
#  set {
#    name  = "account"
#    value = "8e8c7cc1-0ffb-4abc-be56-cf0228d358f3"
#  }
#  set {
#    name  = "clusterName"
#    value = "kubectl config current-context"
#  }
#
#  values = [
#    file("kubescape/cloud-operator/values.yaml"),
#  ]
#}

# ortelius backstage https://github.com/ortelius/Backstage
# resource "helm_release" "backstage" {
#  name             = "backstage"
#  chart            = "backstage"
#  repository       = "https://github.com/ortelius/backstage"
#  namespace        = "backstage"
#  create_namespace = true
#  depends_on       = [kind_cluster.ortelius]
#  timeout = 600
#
#  values = [
#    file("backstage/values.yaml"),
#  ]
#}

# keptn-ortelius-service
#resource "helm_release" "keptn" {
#  name             = "keptn"
#  chart            = "keptn-ortelius-service"
#  repository       = "https://ortelius.github.io/keptn-ortelius-service"
#  namespace        = "keptn"
#  create_namespace = true
#  depends_on       = [kind_cluster.ortelius]
#  timeout = 600
#  values = [file("keptn-ortelius-service/values.yaml")]
#}
