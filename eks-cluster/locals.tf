locals {
  default_fargate_profiles = {
    k8s-fargate-profile = {
      name = "coredns"
      selectors = [
        # {
        #   namespace = "kube-system"
        # },
        {
          namespace = "karpenter"
        },
        {
          namespace = var.namespace
        }
        # {
        #   namespace = "argocd"
        # }
      ]
      subnet_ids = flatten([data.terraform_remote_state.vpc_state.outputs.private_subnets])
    }
  }
}
locals {
  custom_fargate_profiles = {
    k8s-fargate-profile = {
      name = "coredns"
      selectors = [
        # {
        #   namespace = "kube-system"
        # },
        {
          namespace = "karpenter"
        }

      ]
      subnet_ids = flatten([data.terraform_remote_state.vpc_state.outputs.private_subnets])
    }
  }
}

