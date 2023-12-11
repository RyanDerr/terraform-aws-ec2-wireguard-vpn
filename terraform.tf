terraform {
  required_version = ">=1.6"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.30.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = ">=4.0.5"
    }
    null = {
      source  = "hashicorp/null"
      version = ">=3.2.2"
    }
    external = {
      source  = "hashicorp/external"
      version = ">=2.3.2"
    }
  }
}