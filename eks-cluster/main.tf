module "eks" {
  source                         = "terraform-aws-modules/eks/aws"
  version                        = "20.8.5"
  cluster_version                = "1.28"
  cluster_name                   = var.aws_eks_cluster
  cluster_endpoint_public_access = true
  vpc_id                         = data.terraform_remote_state.vpc_state.outputs.vpc_id
  subnet_ids                     = concat(data.terraform_remote_state.vpc_state.outputs.private_subnets, data.terraform_remote_state.vpc_state.outputs.public_subnets)
  enable_irsa                    = true
  eks_managed_node_group_defaults = {
    disk_size = 50
  }

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
    aws-ebs-csi-driver = {
      service_account_role_arn = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${var.aws_eks_cluster}-ebs-csi-controller"
    }
  }
  eks_managed_node_groups = {
  tools = {
    name         = "poc-node-group"
    min_size     = 1
    max_size     = 5
    desired_size = 1

    instance_types = ["t3.xlarge"]
    capacity_type  = "ON_DEMAND"

    update_config = {
      max_unavailable_percentage = 50 # or set `max_unavailable`
    }
  }
}

  # eks_managed_node_groups = var.deploy_application_on_fargate ? {} : local.default_eks_managed_node_groups #var.eks_managed_node_groups
  fargate_profiles        = var.deploy_application_on_fargate ? local.default_fargate_profiles : {}
  cluster_security_group_tags = merge(var.resource_tags, {
    "karpenter.sh/discovery" = "ogm-eks-${var.environment}"
  })
  node_security_group_tags = merge(var.resource_tags, {
    "karpenter.sh/discovery/${var.aws_eks_cluster}-node" : var.aws_eks_cluster
  })
}



#####EBS
locals {
  ebs_csi_service_account_namespace = "kube-system"
  ebs_csi_service_account_name      = "ebs-csi-controller-sa"
}

module "ebs_csi_controller_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-assumable-role-with-oidc"
  version                       = "5.11.1"
  create_role                   = true
  role_name                     = "${var.aws_eks_cluster}-ebs-csi-controller"
  provider_url                  = replace(module.eks.cluster_oidc_issuer_url, "https://", "")
  role_policy_arns              = [aws_iam_policy.ebs_csi_controller.arn]
  oidc_fully_qualified_subjects = ["system:serviceaccount:${local.ebs_csi_service_account_namespace}:${local.ebs_csi_service_account_name}"]
}

resource "aws_iam_policy" "ebs_csi_controller" {
  name_prefix = "ebs-csi-controller-${var.environment}"
  description = "EKS ebs-csi-controller policy for cluster ${var.aws_eks_cluster}"
  policy      = file("${path.module}/ebs_csi_controller_iam_policy.json")
}
