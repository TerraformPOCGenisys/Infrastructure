module "eks" {
  source                         = "terraform-aws-modules/eks/aws"
  version                        = "20.8.5"
  cluster_version                = "1.28"
  cluster_name                   = var.aws_eks_cluster
  cluster_endpoint_public_access = true
  vpc_id                         = data.terraform_remote_state.vpc_state.outputs.vpc_id
  subnet_ids                     = concat(data.terraform_remote_state.vpc_state.outputs.private_subnets, data.terraform_remote_state.vpc_state.outputs.public_subnets)
  enable_irsa                    = true
  # eks_managed_node_group_defaults = {
  #   disk_size = 50
  # }

  access_entries = {
    genisysteam = {
      kubernetes_group = []
      principal_arn    = var.user #"arn:aws:iam::047249942995:user/dhruv-wowlteam"

      policy_associations = {
        admin = {
          policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
          access_scope = {
            namespaces = []
            type       = "cluster"
          }
        }
      }
    }
    # gitlab-k8s-user = {
    #   kubernetes_group = []
    #   principal_arn     = var.gitlab_user #"arn:aws:iam::047249942995:user/dhruv-wowlteam"

    #   policy_associations = {
    #     admin = {
    #       policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
    #       access_scope = {
    #         namespaces = []
    #         type       = "cluster"
    #       }
    #     }
    #     }
    #   }
  }
  cluster_addons = {
    coredns = {
      preserve          = true
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
    }
    vpc-cni = {
      most_recent       = true
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
      most_recent = true
    }
    # aws-ebs-csi-driver = {
    #   most_recent              = true
    #   resolve_conflicts        = "OVERWRITE"
    #   service_account_role_arn = aws_iam_role.ebs_csi_driver_role.arn
    # }
  }
  # eks_managed_node_groups = var.eks_managed_node_groups
  # fargate_profiles        = merge(var.fargate_profiles)
  fargate_profiles = {
    k8s-fargate-profile = {
      name = "coredns"
      selectors = [
        {
          namespace = "kube-system"
        },
        {
          namespace = "default"
        },
        {
          namespace = "${var.namespace}"
        },
        {
          namespace = "*"
        }
      ]
      subnet_ids = flatten([data.terraform_remote_state.vpc_state.outputs.private_subnets])
    }
  }
  cluster_security_group_tags = merge(var.resource_tags, {
    "karpenter.sh/discovery" = "ogm-eks-${var.environment}"
  })
  node_security_group_tags = merge(var.resource_tags, {
    "karpenter.sh/discovery/${var.aws_eks_cluster}-node" : var.aws_eks_cluster
  })
}


