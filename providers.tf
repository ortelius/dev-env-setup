terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "~>0.0.15"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~>1.14.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~>2.7.1"
    }

    null = {
      source  = "hashicorp/null"
      version = "~>3.2.0"
    }
  }
  required_version = "~>1.3.5"
}

provider "null" {
  # Configuration options
}
