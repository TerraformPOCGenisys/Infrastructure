aws_eks_cluster  = "eks-stag-poc"
aws_region = "ap-south-1"
# provisioner = "staging"
# profile = "ogm-india"

deploy_application_on_fargate = false         ######IMP : put the same value as it was inserted in eks-cluster values files


######backend config for EKS cluster######
data_cluster_state_bucket     = "terraformstatebucketcm"
data_cluster_state_bucket_key = "eks-cluster/terraform.state"
data_cluster_state_region     = "ap-south-1"
data_cluster_state_profile    = "default"
data_cluster_state_dynamodb   = "terraformstatebucketcm"