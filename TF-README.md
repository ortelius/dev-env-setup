# dev-env-setup

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~>1.3.5 |
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~>2.7.1 |
| <a name="requirement_kind"></a> [kind](#requirement\_kind) | ~>0.0.15 |
| <a name="requirement_kubectl"></a> [kubectl](#requirement\_kubectl) | ~>1.14.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_helm"></a> [helm](#provider\_helm) | 2.7.1 |
| <a name="provider_kind"></a> [kind](#provider\_kind) | 0.0.16 |
| <a name="provider_kubectl"></a> [kubectl](#provider\_kubectl) | 1.14.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [helm_release.localstack](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [helm_release.ortelius](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [kind_cluster.ortelius](https://registry.terraform.io/providers/tehcyx/kind/latest/docs/resources/cluster) | resource |
| [kubectl_manifest.localstack_apikey](https://registry.terraform.io/providers/gavinbunney/kubectl/latest/docs/resources/manifest) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_kind_cluster_config_path"></a> [kind\_cluster\_config\_path](#input\_kind\_cluster\_config\_path) | Cluster's kubeconfig location | `string` | `"~/.kube/config"` | no |
| <a name="input_kind_cluster_name"></a> [kind\_cluster\_name](#input\_kind\_cluster\_name) | The name of the cluster | `string` | `"ortelius"` | no |
| <a name="input_localstack_api_key"></a> [localstack\_api\_key](#input\_localstack\_api\_key) | LocalStack API Key | `string` | `null` | no |
| <a name="input_ortelius_namespace"></a> [ortelius\_namespace](#input\_ortelius\_namespace) | The Ortelius namespace | `string` | `"ortelius"` | no |

## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
