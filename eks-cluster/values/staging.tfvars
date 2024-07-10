environment     = "staging"
namespace       = "poc"
region          = "ap-south-1"
aws_eks_cluster = "eks-stag-poc"
//fargate_profiles = {}
# profile = "default"
user    = "arn:aws:iam::352730764496:user/terraform-user"
resource_tags = {
  "Created By" : "Genisys-POC"
  "Maintained By" : "Genisys-POC"
  "Owner" : "Genisys"
  "Enviornment" : "staging"
  "Sensitivity" : "yes"
  "Managed By" = "Terraform"
}
deploy_application_on_fargate = false

# gitlab_user = "arn:aws:iam::xxxxxxxxxxxxxxxxxxx:user/gitlab-k8s-user"

####data-remote-state-variable-values

data_vpc_state_bucket         = "terraformstatebucketcm"
data_vpc_state_key            = "vpc/terraform.state"
data_vpc_state_region         = "ap-south-1"
data_vpc_state_dynamodb_table = "terraformstatebucketcm"
data_vpc_state_profile        = "default"



##################################EC2#################
eks_managed_node_groups = {
  tools = {
    name         = "poc-node-group"
    min_size     = 1
    max_size     = 5
    desired_size = 3

    instance_types = ["t3.xlarge"]
    capacity_type  = "ON_DEMAND"

    update_config = {
      max_unavailable_percentage = 50 # or set `max_unavailable`
    }
  }
}



############################Fargate#################


# {
#     k8s-fargate-profile = {
#       name = "coredns"
#       selectors = [
#         {
#           namespace = "kube-system"
#         },
#         {
#           namespace = "default"
#         },
#         {
#           namespace = "${var.namespace}"
#         },
#         {
#           namespace = "*"
#         }
#       ]
#       subnet_ids = flatten([data.terraform_remote_state.vpc_state.outputs.private_subnets])
#     }
#   }
