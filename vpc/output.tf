output "vpc_id" {
  value = module.vpc.vpc_id
}
output "vpc_cidr_block" {
  value = module.vpc.vpc_cidr_block

}
output "private_subnets" {
  value =module.vpc.private_subnets
}

output "public_subnets" {
  value = module.vpc.public_subnets
}

# output "db_subnets" {
#   value = module.vpc.database_subnets
# }

# output "db_route_tables" {
#   value = module.vpc.database_route_table_ids
# }

output "private_route_tables" {
  value = module.vpc.private_route_table_ids
}

output "public_route_tables" {
  value = module.vpc.public_route_table_ids
}
