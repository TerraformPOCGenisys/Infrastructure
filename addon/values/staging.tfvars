aws_eks_cluster = "eks-stag-poc"
aws_region      = "ap-south-1"
namespace       = "staging"
env             = "staging"
# profile         = "default"

######backend config for EKS cluster######
data_cluster_state_bucket     = "terraformstatebucketcm"
data_cluster_state_bucket_key = "eks-clusters/terraform.state"
data_cluster_state_region     = "ap-south-1"
data_cluster_state_profile    = "default"
data_cluster_state_dynamodb   = "terraformstatebucketcm"
####backend config for VPC #####
data_vpc_state_bucket     = "terraformstatebucketcm"
data_vpc_state_bucket_key = "vpc/terraform.state"
data_vpc_state_dynamodb   = "terraformstatebucketcm"
data_vpc_state_region     = "ap-south-1"
data_vpc_state_profile    = "default"
