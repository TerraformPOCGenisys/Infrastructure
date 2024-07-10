# variable "environment" {
#   type        = string
# }

# variable "iam_policy_karpenter" {
#   type        = string
#   default = ""
# }

variable "deploy_application_on_fargate" {
  description = "Flag to deploy Fargate profiles instead of Karpenter"
  type        = bool
  default     = false
}
# variable "provisioner" {
#   type = string
# }
variable "aws_eks_cluster" {
  type = string
}
variable "aws_region" {
  type = string
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

# variable "data_cluster_state_profile" {
#   description = "AWS profile for remote state storage"
#   type        = string
# }

variable "data_cluster_state_bucket" {
  description = "s3 bucket"
  type        = string
}

variable "data_cluster_state_dynamodb" {
  description = "dynamo"
  type        = string
}