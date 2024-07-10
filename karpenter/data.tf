
data "aws_caller_identity" "current" {}

data "terraform_remote_state" "cluster" {
  backend = "s3"
  config = {
    bucket         = var.data_cluster_state_bucket 
    key            = var. data_cluster_state_bucket_key 
    region         = var.data_cluster_state_region 
    # profile        = var.data_cluster_state_profile 
  }
}

data "aws_eks_cluster" "cluster" {
  name = var.aws_eks_cluster
}

data "aws_eks_cluster_auth" "cluster" {
  name = var.aws_eks_cluster
}


# data "aws_ecrpublic_authorization_token" "token" {
#   #  provider = aws
# }
