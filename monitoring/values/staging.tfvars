#name of the eks cluster,this is used to label or add this name in the resource to identify easily from aws console
eks_cluster_name = "eks-stag-poc"
aws_region = "ap-south-1"
grafana_version = "8.3.2"
loki_version = "0.79.0"
k8s_monitoring_version = "1.3.0"
monitoring_namespace = "monitoring"
# profile = "default"
env = "staging"
#add acm certificate of your domain
acm_certificate = "arn:aws:acm:ap-south-1:352730764496:certificate/4302a7b9-0ef7-4e05-8e4b-88e89ada1991"
alb_ingress_class = "alb"

#add full domain to add for your grafana
grafana_host_name = "grafana-staging.cmrinfo.in"

######backend config for EKS cluster######
data_cluster_state_bucket = "terraformstatebucketcm"
data_cluster_state_bucket_key = "eks-cluster/terraform.state"
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
data_addon_state_bucket_key = "addon/terraform.state"
data_addon_state_region  = "ap-south-1"
data_addon_state_profile  = "default"
data_addon_state_dynamodb = "terraformstatebucketcm"



