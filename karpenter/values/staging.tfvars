aws_eks_cluster  = "eks-stag-poc"
aws_region = "ap-south-1"


###IMP :put the same value as it was inserted in eks-cluster values files
deploy_application_on_fargate = true     

######backend config for EKS cluster######
data_cluster_state_bucket     = "terraformstatebucketcm"
data_cluster_state_bucket_key = "eks-cluster/terraform.state"
data_cluster_state_region     = "ap-south-1"
data_cluster_state_profile    = "default"
data_cluster_state_dynamodb   = "terraformstatebucketcm"