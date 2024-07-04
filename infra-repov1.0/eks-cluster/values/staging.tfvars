environment     = "staging"
namespace       = "poc"
region          = "ap-south-1"
aws_eks_cluster = "eks-stag-poc"
//fargate_profiles = {}
profile = "default"
user    = "arn:aws:iam::352730764496:user/terraform-user"
resource_tags = {
  "Created By" : "Genisys-POC"
  "Maintained By" : "Genisys-POC"
  "Owner" : "Genisys"
  "Enviornment" : "staging"
  "Sensitivity" : "yes"
  "Managed By" = "Terraform"
}

# gitlab_user = "arn:aws:iam::xxxxxxxxxxxxxxxxxxx:user/gitlab-k8s-user"

####data-remote-state-variable-values

data_vpc_state_bucket         = "terraformstatebucketcm"
data_vpc_state_key            = "vpc/terraform.state"
data_vpc_state_region         = "ap-south-1"
data_vpc_state_dynamodb_table = "terraformstatebucketcm"
data_vpc_state_profile        = "default"
