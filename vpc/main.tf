# VPC

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"
  name    = "${var.environment_name}-vpc"
  cidr    = var.vpc_cidr
  azs     = var.azs
  # private_subnets                      = [cidrsubnet(var.vpc_cidr, 8, 2), cidrsubnet(var.vpc_cidr, 8, 5)]
  public_subnets  = [var.public_subnets[0], var.public_subnets[1]]   #[cidrsubnet(var.vpc_cidr, 8, 0), cidrsubnet(var.vpc_cidr, 8, 1)]
  private_subnets = [var.private_subnets[0], var.private_subnets[1]] #[cidrsubnet(var.vpc_cidr, 8, 6), cidrsubnet(var.vpc_cidr, 8, 7)]
  # create_database_subnet_route_table   = var.create_database_subnet_route_table
  enable_vpn_gateway                   = var.enable_vpn_gateway
  enable_nat_gateway                   = var.enable_nat_gateway
  single_nat_gateway                   = var.single_nat_gateway
  map_public_ip_on_launch              = true
  enable_flow_log                      = true
  create_flow_log_cloudwatch_iam_role  = true
  create_flow_log_cloudwatch_log_group = true
  enable_dns_hostnames                 = true
  public_subnet_suffix                 = "${var.environment_name}-public-subnet"
  # database_subnet_suffix               = var.db_subnet_cidrs == [] ? null : "db-subnet"
  private_subnet_suffix = "${var.environment_name}-private-subnet"
  private_subnet_tags = merge(var.resource_tags, {
    "Name" : "${var.environment_name}-private-subnet",
    "kubernetes.io/role/internal-elb" : "1"
  })
  # database_subnet_tags = var.db_subnet_cidrs == [] ? {} : merge(var.resource_tags, {
  #   "Name" : " -${var.environment_name}-vpc-private-db-subnet",
  #   "kubernetes.io/role/internal-elb": "1"
  # })
  public_subnet_tags = merge(var.resource_tags, {
    "Name" : "${var.environment_name}-public-subnet",
    "kubernetes.io/role/elb" : "1",
    "karpenter.sh/discovery" : var.aws_eks_cluster
  })
  tags = merge(var.resource_tags, {
    "Name" = "${var.environment_name}"
  })
  # database_route_table_tags = var.db_subnet_cidrs == [] ? {} : merge(var.resource_tags, {
  #   "Name" : "${var.environment_name}-vpc-db-route-table"
  # })
  private_route_table_tags = merge(var.resource_tags, {
    "Name" : "${var.environment_name}-private-route-table"
  })
  public_route_table_tags = merge(var.resource_tags, {
    "Name" : "${var.environment_name}-public-route-table"
  })
}
