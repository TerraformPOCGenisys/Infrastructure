

resource "kubernetes_namespace" "project" {
  metadata {
    annotations = {
      name = var.namespace
    }

    labels = {
      mylabel = var.namespace
    }

    name = var.namespace
  }
}
# # VPC-CNI

module "vpc_cni_irsa" {
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name = "vpc-cni-role-${var.aws_eks_cluster}"

  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true

  oidc_providers = {
    main = {
      provider_arn               = data.terraform_remote_state.cluster.outputs.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-node"]
    }
  }

  tags = {
    Name = "vpc-cni-irsa"
  }
}



# ####ebs addon
# resource "aws_eks_addon" "addons" {

#   for_each          = { for addon in var.addons : addon.name => addon }
#   cluster_name      = var.aws_eks_cluster
#   addon_name        = each.value.name
#   addon_version     = each.value.version
#   resolve_conflicts = "OVERWRITE"

# }




####alb role###
module "lb_role" {

  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"

  role_name                              = "eks-alb-controller-role-${var.aws_eks_cluster}"
  attach_load_balancer_controller_policy = true

  oidc_providers = {
    main = {
      provider_arn               = data.terraform_remote_state.cluster.outputs.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}




###########
resource "helm_release" "lb" {
  #depends_on = [  module.lb_role , kubernetes_service_account.service-account]
  depends_on = [kubernetes_service_account.service-account]
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"


  set {
    name  = "region"
    value = var.aws_region
  }

  set {
    name  = "vpcId"
    value = data.terraform_remote_state.vpc_state.outputs.vpc_id #data.terraform_remote_state.vpc.outputs.vpc_id
  }

  set {
    name  = "image.repository"
    value = "602401143452.dkr.ecr.eu-west-2.amazonaws.com/amazon/aws-load-balancer-controller"
  }

  set {
    name  = "serviceAccount.create"
    value = "false"
  }

  set {
    name  = "serviceAccount.name"
    value = "aws-load-balancer-controller"
  }

  set {
    name  = "clusterName"
    value = var.aws_eks_cluster
  }
}

resource "kubernetes_service_account" "service-account" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = module.lb_role.iam_role_arn #"arn:aws:iam::********:role/eks-alb-controller-role-${var.aws_eks_cluster}" 
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}

# resource "helm_release" "metric-server" {
#   name       = "metric-server"
#   repository = "https://charts.bitnami.com/bitnami" 
#   chart      = "metrics-server"
#   namespace = "kube-system"
#   set {
#     name  = "apiService.create"
#     value = "true"
#   }
# }


############service account for deployments

# Trusted entities
data "aws_iam_policy_document" "serviceAccount_for_all_assume_role_policy" {

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringLike"
      variable = "${replace(data.terraform_remote_state.cluster.outputs.cluster_oidc_issuer_url, "https://", "")}:sub"
      values   = ["system:serviceaccount:*:service-account-${var.aws_eks_cluster}"]
    } #module.eks.cluster_oidc_issuer_url

    condition {
      test     = "StringLike"
      variable = "${replace(data.terraform_remote_state.cluster.outputs.cluster_oidc_issuer_url, "https://", "")}:aud"
      values   = ["sts.amazonaws.com"]
    }

    principals {
      identifiers = [data.terraform_remote_state.cluster.outputs.oidc_provider_arn]
      type        = "Federated"
    } #oidc_provider_arn
  }
}

# # Policy
resource "aws_iam_policy" "policy2" {

  name = "secret-manger-policy-${var.aws_eks_cluster}"

  policy = jsonencode({
    Version = "2012-10-17"

    Statement = [{
      Effect = "Allow"
      Action = [
        "secretsmanager:GetSecretValue",
        "secretsmanager:DescribeSecret",
        "ecr:*"
      ]
      Resource = ["*"]
    }]
  })
}


# # Role
resource "aws_iam_role" "role2" {

  assume_role_policy  = data.aws_iam_policy_document.serviceAccount_for_all_assume_role_policy.json
  name                = "k8s-deployment-role-${var.aws_eks_cluster}"
  managed_policy_arns = [aws_iam_policy.policy2.arn]
}



resource "kubectl_manifest" "service_account_deployment" {

  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  name: service-account-${var.aws_eks_cluster}
  namespace: ${var.namespace}
  annotations:
    eks.amazonaws.com/role-arn: ${aws_iam_role.role2.arn}
YAML


}



###############secret manager####################

# resource "helm_release" "secrets-store-csi-driver" {
#   name       = "secrets-store-csi-driver"
#   repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
#   chart      = "secrets-store-csi-driver"
#   version    = "1.3.4"
#   namespace  = "kube-system"
#   timeout    = 10 * 60

#   values = [
#     <<VALUES
#     syncSecret:
#       enabled: true   # Install RBAC roles and bindings required for K8S Secrets syncing if true (default: false)
#     enableSecretRotation: true

#     ## Secret rotation poll interval duration
#     ##rotationPollInterval: 3600m
# VALUES
#   ]
# }
# # data "aws_eks_cluster_auth" "cluster" {
# #   name = var.aws_eks_cluster#module.eks.cluster_name
# # }
# data "kubectl_file_documents" "aws-secrets-manager" {
#   content = file("aws-secret-manager.yaml")
# }
# # https://raw.githubusercontent.com/aws/secrets-store-csi-driver-provider-aws/main/deployment/aws-provider-installer.yaml

# resource "kubectl_manifest" "aws-secrets-manager" {
#   for_each  = data.kubectl_file_documents.aws-secrets-manager.manifests
#   yaml_body = each.value
# }


# # Trusted entities
# data "aws_iam_policy_document" "secrets_csi_assume_role_policy" {
#   statement {
#     actions = ["sts:AssumeRoleWithWebIdentity"]
#     effect  = "Allow"

#     condition {
#       test     = "StringLike"
#       variable = "${replace(data.terraform_remote_state.cluster.outputs.cluster_oidc_issuer_url, "https://", "")}:sub"
#       values   = ["system:serviceaccount:*:secrets-csi-policy-sa-${var.env}"]
#     }
#     #module.eks.cluster_oidc_issuer_url
#     condition {
#       test     = "StringLike"
#       variable = "${replace(data.terraform_remote_state.cluster.outputs.cluster_oidc_issuer_url, "https://", "")}:aud"
#       values   = ["sts.amazonaws.com"]
#     }

#     principals {
#       identifiers = [data.terraform_remote_state.cluster.outputs.oidc_provider_arn]
#       type        = "Federated"
#     }
#   }
# }
# #module.eks.oidc_provider_arn
# # Role
# resource "aws_iam_role" "secrets_csi" {

#   assume_role_policy = data.aws_iam_policy_document.secrets_csi_assume_role_policy.json
#   name               = "secrets-csi-role-${var.env}"
# }

# # Policy
# resource "aws_iam_policy" "secrets_csi" {

#   name = "secrets-csi-policy-${var.env}"

#   policy = jsonencode({
#     Version = "2012-10-17"

#     Statement = [{
#       Effect = "Allow"
#       Action = [
#         "secretsmanager:GetSecretValue",
#         "secretsmanager:DescribeSecret"
#       ]
#       Resource = ["*"]
#     }]
#   })
# }

# data "aws_secretsmanager_secret" "secrets_csi" {
#   name = var.aws_secret_manager_name #"test-secret"
# }

# # Policy Attachment
# resource "aws_iam_role_policy_attachment" "secrets_csi" {

#   policy_arn = aws_iam_policy.secrets_csi.arn
#   role       = aws_iam_role.secrets_csi.name
# }

# # Service Account
# resource "kubectl_manifest" "secrets_csi_sa" {

#   yaml_body = <<YAML
# apiVersion: v1
# kind: ServiceAccount
# metadata:
#   name: secrets-csi-policy-sa-${var.env}
#   namespace: kube-system
#   annotations:
#     eks.amazonaws.com/role-arn: ${aws_iam_role.secrets_csi.arn}
# YAML

# }
