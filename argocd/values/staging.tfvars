eks_cluster_name = "eks-stag-poc"
aws_region       = "ap-south-1"
env              = "staging"
argocd_version   = "5.24.1"
# profile          = "default"
# karpenter_staging_provisioner_name = "eks-stag-orbit-node"
acm_certificate                   = "arn:aws:acm:ap-south-1:352730764496:certificate/4302a7b9-0ef7-4e05-8e4b-88e89ada1991"
alb_ingress_class                 = "alb"
argocd_host_name                  = "argocd-staging.cmrinfo.in"
namespace_argocd                  = "argocd"
argocd_service_name               = "argocd"
ecr_api_url                       = "https://211125597478.dkr.ecr.ap-south-1.amazonaws.com"
ecr_prefix_url                    = "211125597478.dkr.ecr.ap-south-1.amazonaws.com"
argocd_image_updater_service_name = "argocd-image-updater"
argocd_image_updater_version      = "0.9.7"


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


######backend config for ADDON cluster######
data_addon_state_bucket     = "terraformstatebucketcm"
data_addon_state_bucket_key = "addons/terraform.state"
data_addon_state_dynamodb   = "terraformstatebucketcm"
data_addon_state_region     = "ap-south-1"
data_addon_state_profile    = "default"

