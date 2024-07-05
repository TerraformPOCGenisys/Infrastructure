# VPC

variable "resource_tags" {
  description = "Common tags to apply for all resources"
  type        = any

  default = {
    "Created By" : "cirrops-team"
    # "Maintained By" : "cirrops-team"
    # "Owner" : "cultus"
    # "Sensitivity" : "yes"
    # "Managed By"  = "Terraform"

  }
}

variable "namespace" {
  description = "Prefix for the VPC"
  type        = any

  default = "ogm"
}
variable "aws_eks_cluster" {

}
# variable "profile" {

# }

variable "aws_region" {
  description = "AWS aws_region to launch the environment"
  type        = any

  default = ""
}

variable "environment_name" {
  description = "Name of the environment"
  type        = any

  default = ""
}

variable "vpc_cidr" {
  description = "IP CIDR for VPC"
  type        = any

  default = ""
}






# variable "private_subnet_cidrs" {
#   type    = list(string)
#   default = []
# }

# variable "public_subnet_cidrs" {
#   type    = list(string)
#   default = []
# }

# variable "db_subnet_cidrs" {
#   type    = list(string)
#   default = []
# }

variable "enable_vpn_gateway" {
  description = "Whether to enable VPN gateway"
  type        = bool

  default = false
}

variable "enable_nat_gateway" {
  description = "Whether to add NAT gateway"
  type        = bool

  default = false
}

variable "single_nat_gateway" {
  description = "Whether to add single NAT gateway"
  type        = bool

  default = false
}

variable "create_database_subnet_route_table" {
  description = "Whether to create separate route table for DB subnets"
  type        = bool

  default = false
}

variable "azs" {
  description = "azs"
  type        = list(string)

  default = []
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}
