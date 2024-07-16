eks_cluster_name = "eks-stag-poc"
aws_region       = "ap-south-1"
env              = "staging"
argocd_version   = "5.24.1"
# profile          = "default"
#add acm certificate for your domain
acm_certificate                   = "arn:aws:acm:ap-south-1:352730764496:certificate/4302a7b9-0ef7-4e05-8e4b-88e89ada1991"
alb_ingress_class                 = "alb"
#add fulldomain to be attached with argocd
argocd_host_name                  = "argocd-staging.cmrinfo.in"
namespace_argocd                  = "argocd"
argocd_service_name               = "argocd"
argocd_image_updater_service_name = "argocd-image-updater"
argocd_image_updater_version      = "0.9.7"
#add your office ip or ip that need to be whitelisted to aceess argocd and grafana
ingress_cidrs_sg = ["0.0.0.0/0"]


######backend config for EKS cluster######
data_cluster_state_bucket     = "terraformstatebucketcm"
data_cluster_state_bucket_key = "eks-cluster/terraform.state"
data_cluster_state_region     = "ap-south-1"
data_cluster_state_profile    = "default"
data_cluster_state_dynamodb   = "terraformstatebucketcm"

####backend config for VPC #####
data_vpc_state_bucket     = "terraformstatebucketcm"
data_vpc_state_bucket_key = "vpc/terraform.state"
data_vpc_state_dynamodb   = "terraformstatebucketcm"
data_vpc_state_region     = "ap-south-1"
data_vpc_state_profile    = "default"


######backend config for ADDON cluster######
data_addon_state_bucket     = "terraformstatebucketcm"
data_addon_state_bucket_key = "addon/terraform.state"
data_addon_state_dynamodb   = "terraformstatebucketcm"
data_addon_state_region     = "ap-south-1"
data_addon_state_profile    = "default"

######backend config for ECR cluster######
data_ecr_state_bucket     = "terraformstatebucketcm"
data_ecr_state_bucket_key = "ecr/terraform.state"
data_ecr_state_dynamodb   = "terraformstatebucketcm"
data_ecr_state_region     = "ap-south-1"
data_ecr_state_profile    = "default"

