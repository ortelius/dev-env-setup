# terraform

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.3.4 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 4.38.0 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | 2.7.1 |
| <a name="requirement_kind"></a> [kind](#requirement\_kind) | ~> 0.0.15 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~> 1.14.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | 2.15.0 |
| <a name="requirement_null"></a> [null](#requirement\_null) | 3.2.0 |
| <a name="requirement_time"></a> [time](#requirement\_time) | 0.9.1 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.7.1 |
| <a name="provider_kind"></a> [kind](#provider\_kind) | 0.0.15 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.0 |
| <a name="provider_time"></a> [time](#provider\_time) | 0.9.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_istio"></a> [istio](#module\_istio) | sepulworld/istio/helm | 0.0.3 |

## Resources

| Name | Type |
|------|------|
| [helm_release.argocd](https://registry.terraform.io/providers/hashicorp/helm/2.7.1/docs/resources/release) | resource |
| [helm_release.istio_base](https://registry.terraform.io/providers/hashicorp/helm/2.7.1/docs/resources/release) | resource |
| [helm_release.istio_istiod](https://registry.terraform.io/providers/hashicorp/helm/2.7.1/docs/resources/release) | resource |
| [helm_release.keptn](https://registry.terraform.io/providers/hashicorp/helm/2.7.1/docs/resources/release) | resource |
| [kind_cluster.ortelius](https://registry.terraform.io/providers/tehcyx/kind/latest/docs/resources/cluster) | resource |
| [null_resource.kind_container_images](https://registry.terraform.io/providers/hashicorp/null/3.2.0/docs/resources/resource) | resource |
| [null_resource.kubectl](https://registry.terraform.io/providers/hashicorp/null/3.2.0/docs/resources/resource) | resource |
| [time_sleep.wait_45_seconds](https://registry.terraform.io/providers/hashicorp/time/0.9.1/docs/resources/sleep) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ingress_nginx_helm_version"></a> [ingress\_nginx\_helm\_version](#input\_ingress\_nginx\_helm\_version) | The Helm version for the nginx ingress controller. | `string` | `"4.3.0"` | no |
| <a name="input_ingress_nginx_namespace"></a> [ingress\_nginx\_namespace](#input\_ingress\_nginx\_namespace) | The nginx ingress namespace | `string` | `"ingress-nginx"` | no |
| <a name="input_kind_cluster_config_path"></a> [kind\_cluster\_config\_path](#input\_kind\_cluster\_config\_path) | Cluster's kubeconfig location | `string` | `"~/.kube/config"` | no |
| <a name="input_kind_cluster_name"></a> [kind\_cluster\_name](#input\_kind\_cluster\_name) | The name of the cluster. | `string` | `"ortelius-in-a-box"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
