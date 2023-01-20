variable "kind_cluster_name" {
  type        = string
  description = "The name of the cluster."
  default     = "ortelius"
}

variable "kind_cluster_config_path" {
  type        = string
  description = "Cluster's kubeconfig location"
  default     = "~/.kube/config"
}

variable "ingress_nginx_namespace" {
  type        = string
  description = "The nginx ingress namespace"
  default     = "ingress-nginx"
}

variable "purelb_namespace" {
  type        = string
  description = "The PureLB loadbalancer namespace"
  default     = "purelb"
}
