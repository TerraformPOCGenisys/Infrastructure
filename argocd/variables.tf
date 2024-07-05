variable "aws_region" {
  description = "AWS aws_region to launch the environment"
  type        = any

  default = ""
}
variable "env" {
  description = "AWS aws_region to launch the environment"
  type        = any

  default = ""
}

variable "alb_ingress_class" {
  default = ""
}
variable "eks_cluster_name" {
  default = ""
}


variable "ecr_api_url" {
  default = ""
}
variable "ecr_prefix_url" {
  default = ""
}

variable "argocd_image_updater_service_name" {
  default = ""
}
variable "argocd_image_updater_version" {
  default = ""
}
variable "namespace_argocd" {
  default = ""
}
variable "argocd_service_name" {
  default = ""
}
variable "acm_certificate" {
  default = ""
}
variable "oidc_id" {
  default = ""
}
variable "argocd_host_name" {
  default = ""
}

variable "resource_tags" {
  description = "Common tags to apply for all resources"
  type        = any

  default = {
    "ManagedBy" = "Terraform"
    "Owner"     = "monie"
  }
}

variable "env_name" {
  default = ""
}






variable "profile" {
  type        = string
  default     = "default"
  description = "Name of AWS profile"
}




variable "argocd_version" {
  type        = string
  default     = ""
  description = "helm version to install"
}

variable "karpenter_staging_provisioner_name" {
  default     = ""
  description = ""
}

####################remote data for cluster  tf state############
variable "data_cluster_state_bucket_key" {
  description = "Key for remote state storage"
  type        = string
}

variable "data_cluster_state_region" {
  description = "Region for remote state storage"
  type        = string
}

variable "data_cluster_state_profile" {
  description = "AWS profile for remote state storage"
  type        = string
}

variable "data_cluster_state_bucket" {
  description = "s3 bucket"
  type        = string
}

####################remote data for vpc tf state############
variable "data_vpc_state_bucket_key" {
  description = "Key for remote state storage"
  type        = string
}

variable "data_vpc_state_region" {
  description = "Region for remote state storage"
  type        = string
}

variable "data_vpc_state_profile" {
  description = "AWS profile for remote state storage"
  type        = string
}

variable "data_vpc_state_bucket" {
  description = "s3 bucket"
  type        = string
}

####################remote data for vpc tf state############
variable "data_addon_state_bucket_key" {
  description = "Key for remote state storage"
  type        = string
}

variable "data_addon_state_region" {
  description = "Region for remote state storage"
  type        = string
}

variable "data_addon_state_profile" {
  description = "AWS profile for remote state storage"
  type        = string
}

variable "data_addon_state_bucket" {
  description = "s3 bucket"
  type        = string
}

variable "data_cluster_state_dynamodb" {
  description = "dynamo"
  type        = string
}

variable "data_vpc_state_dynamodb" {
  description = "dynamodb"
  type        = string
}

variable "data_addon_state_dynamodb" {
  description = "dynamodb"
  type        = string
}

