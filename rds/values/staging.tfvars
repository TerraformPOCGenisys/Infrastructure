aws_region          = "ap-south-1"
cluster_identifier  = "poc-db-cluster"
db_name             = "poc-stag-db"
engine              = "postgres"
storage_type        = "gp2"
engine_version      = "13.12"
instance_class      = "db.t3.medium"
username            = "postgres"
password            = "qwertyuhgfde5dfw"
# profile             = "default"
publicly_accessible = false

resource_tags = {
  "CreatedBy"      = "poc"
  "CreatedThrough" = "Terraform"
  "Owner"          = "poc"
  "Brand"          = "poc"
  "Environment"    = "poc"
}


####backend config for VPC #####
data_vpc_state_bucket   = "terraformstatebucketcm"
data_vpc_state_key      = "vpc/terraform.state"
data_vpc_state_dynamodb = "terraformstatebucketcm"
data_vpc_state_region   = "ap-south-1"
data_vpc_state_profile  = "default"
