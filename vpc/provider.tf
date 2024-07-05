terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.19.0"
    }
  }

  backend "s3" {}

  required_version = ">= 1.0.0"
}

provider "aws" {
  region  = var.aws_region
  profile = var.profile
}


