data "aws_eks_cluster" "cluster" {
  name = data.terraform_remote_state.cluster.outputs.cluster_name
}

data "aws_eks_cluster_auth" "cluster" {
  name = data.terraform_remote_state.cluster.outputs.cluster_name
}



########
data "terraform_remote_state" "cluster" {
  backend = "s3"
  config = {
    bucket         = var.data_cluster_state_bucket 
    key            = var. data_cluster_state_bucket_key 
    region         = var.data_cluster_state_region 
    # profile        = var.data_cluster_state_profile 
  }
}
data "terraform_remote_state" "vpc_state" {
  backend = "s3"
  config = {
    bucket         =  var.data_vpc_state_bucket
    key            = var.data_addon_state_bucket_key
    region         = var.data_vpc_state_region
    # profile        = var.data_vpc_state_profile
  }
}
data "terraform_remote_state" "addon" {
  backend = "s3"
  config = {
    bucket         = var.data_addon_state_bucket 
    key            = var. data_addon_state_bucket_key 
    region         = var.data_addon_state_region 
    # profile        = var.data_addon_state_profile 
  }
}