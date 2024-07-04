variable "aws_eks_cluster" {

}
variable "aws_region" {

}
# variable "vpc_id" {

# }
variable "profile" {

}

# variable "aws_secret_manager_name" {

# }
variable "addons" {
  description = "Additional addons applied on cluster"
  type = list(object({
    name    = string
    version = string
  }))

  default = [
    {
      name    = "aws-ebs-csi-driver"
      version = "v1.30.0-eksbuild.1"
    }
  ]
}
variable "namespace" {
  description = "namespace for service account"
  type        = string
}
variable "env" {

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
