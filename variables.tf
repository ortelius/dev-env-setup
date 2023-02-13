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

variable "localstack_namespace" {
  type        = string
  description = "The Localstack namespace"
  default     = "localstack"
}

variable "localstack_api_key" {
  type        = string
  description = "LocalStack API Key"
  default     = null
}

variable "backstage_namespace" {
  type        = string
  description = "The Backstage namespace"
  default     = "backstage"
}
