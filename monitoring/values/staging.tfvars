eks_cluster_name = "eks-stag-poc"
aws_region = "ap-south-1"
grafana_version = "7.3.9"
loki_version = "0.79.0"
mimir_version = "5.4.0-weekly.288"
k8s_monitoring_version = "1.3.0"
monitoring_namespace = "monitoring"
# profile = "default"
env = "staging"
acm_certificate = "arn:aws:acm:ap-south-1:352730764496:certificate/4302a7b9-0ef7-4e05-8e4b-88e89ada1991"
alb_ingress_class = "alb"
grafana_host_name = "grafana-staging.cmrinfo.in"

######backend config for EKS cluster######
data_cluster_state_bucket = "terraformstatebucketcm"
data_cluster_state_bucket_key = "eks-clusters/terraform.state"
data_cluster_state_region = "ap-south-1"
data_cluster_state_profile = "default"
data_cluster_state_dynamodb = "terraformstatebucketcm"
####backend config for VPC #####
data_vpc_state_bucket = "terraformstatebucketcm"
data_vpc_state_bucket_key =  "vpc/terraform.state"
data_vpc_state_region = "ap-south-1"
data_vpc_state_profile = "default"
data_vpc_state_dynamodb = "terraformstatebucketcm"
######backend config for ADDON cluster######
data_addon_state_bucket = "terraformstatebucketcm"
data_addon_state_bucket_key = "addons/terraform.state"
data_addon_state_region  = "ap-south-1"
data_addon_state_profile  = "default"
data_addon_state_dynamodb = "terraformstatebucketcm"



