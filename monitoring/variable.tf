variable "aws_region" {
  
}

variable "monitoring_namespace" {
  
}
variable "grafana_version" {
  
}
variable "eks_cluster_name" {
  
}
# variable "profile" {
  
# }
variable "env" {
  
}
variable "acm_certificate" {
  
}
variable "alb_ingress_class" {
  
}
variable "grafana_host_name" {
  
}
variable "loki_version" {
  
}
# variable "mimir_version" {
  
# }
variable "k8s_monitoring_version" {
  
}
####################remote data for addon tf state############
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

variable "data_addon_state_dynamodb" {
  description = "dynamo"
  type        = string
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
variable "data_cluster_state_dynamodb" {
  description = "dynamo"
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
variable "data_vpc_state_dynamodb" {
  description = "dynamodb"
  type        = string
}