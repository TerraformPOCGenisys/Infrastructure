terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.31.0"
    }
  }
  required_version = ">= v1.5.7"
}
