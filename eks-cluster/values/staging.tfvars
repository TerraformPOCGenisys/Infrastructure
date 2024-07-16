environment     = "staging"

##the namespace in which your appliaction will be deployed
namespace       = "staging"

region          = "ap-south-1"

#the name of the eks cluster
aws_eks_cluster = "eks-stag-poc"
#Add the same terraform user through which ci/cd is executing so that that terraform user is ble to create cluster and deploy the resources in terraform.
user    = "arn:aws:iam::352730764496:user/terraform-user"
resource_tags = {
  "Created By" : "Genisys-POC"
  "Maintained By" : "Genisys-POC"
  "Owner" : "Genisys"
  "Enviornment" : "staging"
  "Sensitivity" : "yes"
  "Managed By" = "Terraform"
}
deploy_application_on_fargate = true



####data-remote-state-variable-values
data_vpc_state_bucket         = "terraformstatebucketcm"
data_vpc_state_key            = "vpc/terraform.state"
data_vpc_state_region         = "ap-south-1"
data_vpc_state_dynamodb_table = "terraformstatebucketcm"
data_vpc_state_profile        = "default"





