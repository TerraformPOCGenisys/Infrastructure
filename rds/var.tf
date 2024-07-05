variable "profile" {

}
variable "aws_region" {

}
variable "ingress_cidr_blocks" {
  default = ""
}
######bucket
variable "data_vpc_state_bucket" {
}
variable "data_vpc_state_key" {
}
variable "data_vpc_state_region" {
}
variable "data_vpc_state_profile" {
}
variable "data_vpc_state_dynamodb" {
}

# variable "eks_managed_node_groups" {
# }

variable "instance_class" {

}
variable "username" {

}
variable "password" {

}
variable "db_name" {
  default = ""
}
variable "publicly_accessible" {

}
variable "engine_version" {
  description = "Version of the DB Engine"
  type        = any


}
variable "storage_type" {
  type = string
}
variable "engine" {
  description = "Name of the DB Engine"
  type        = any

}
variable "cluster_identifier" {
  description = "Cluster Identifier for Aurora Cluster"
  type        = string

  default = "NF-backend-db-cluster"
}

variable "resource_tags" {
  description = "Common tags to apply for all resources"
  type        = any

  default = {
    "CreatedBy"      = ""
    "CreatedThrough" = "Terraform"
    "Owner"          = ""
    "Brand"          = ""
    "Environment"    = ""
  }
}
