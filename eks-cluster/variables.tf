variable "aws_eks_cluster" {
  type = string
}

variable "region" {
  type    = string
  default = "us-east-1"
}
variable "resource_tags" {
  description = "Common tags to apply for all resources"
  type        = any

  default = {
    "Created By" : "cirrops-team"

  }
}
variable "aws_access_key" {
  type    = string
  default = ""
}
variable "user" {
  type    = string
  default = ""
}
variable "gitlab_user" {
  type    = string
  default = ""
}
variable "aws_secret_key" {
  type    = string
  default = ""
}
/*variable "fargate_profiles" {
  type = any
}
*/
variable "environment" {
  description = "The name of the environment"
  type        = string
}

/*variable "eks_managed_node_groups" {
  description = "EKS Managed Node Groups"
} 
*/
# variable "profile" {
#   description = ""
# }
/*variable "vpc_id" {
  description = "vpc id"
}
variable "public_subnets_ids" {
  description = "Public Subnet IDs"
}
*/
variable "namespace" {
}


######bucket
variable "data_vpc_state_bucket" {
}
variable "data_vpc_state_key" {
}
variable "data_vpc_state_region" {
}
variable "data_vpc_state_dynamodb_table" {
}
# variable "data_vpc_state_profile" {
# }

variable "eks_managed_node_groups" {
  description = "EKS Managed Node Groups"
}
