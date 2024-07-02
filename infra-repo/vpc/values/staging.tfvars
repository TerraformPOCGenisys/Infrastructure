environment_name                   = "staging"
vpc_cidr                           = "10.0.0.0/16"
azs                                = ["ap-south-1a", "ap-south-1b"]
create_database_subnet_route_table = false
enable_vpn_gateway                 = false
enable_nat_gateway                 = true
single_nat_gateway                 = false
aws_region                         = "ap-south-1"
aws_eks_cluster                    = "eks-stag-poc"
profile                            = "default"
public_subnets                     = ["10.0.0.0/20", "10.0.16.0/20"]
private_subnets                    = ["10.0.32.0/20", "10.0.48.0/20"]
resource_tags = {
  "Created By" : "POC"
  "Maintained By" : "POC"
  "Owner" : "POC"
  "Enviornment" : "staging"
  "Sensitivity" : "yes"
  "Managed By" = "Terraform"
}
