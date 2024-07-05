data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

# data "aws_vpc" "selected" {
#   id = var.vpc_id#data.terraform_remote_state.vpc.outputs.vpc_id
# }

# locals {
#   partition  = join("", data.aws_partition.current.*.partition)
#   region     = data.aws_region.current.name
#   account_id = data.aws_caller_identity.current.account_id
#   db = aws_rds_cluster.default.database_name == null ? "default_db" : aws_rds_cluster.default.database_name
# }

data "aws_partition" "current" {}
