variable "kind_cluster_name" {
  type        = string
  description = "The name of the cluster"
  default     = "ortelius"
}

variable "kind_cluster_config_path" {
  type        = string
  description = "Cluster's kubeconfig location"
  default     = "~/.kube/config"
}

variable "ortelius_namespace" {
  type        = string
  description = "The Ortelius namespace"
  default     = "ortelius"
}

#variable "backstage_namespace" {
#  type        = string
#  description = "The Backstage namespace"
#  default     = "backstage"
#}
