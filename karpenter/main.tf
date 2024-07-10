
################################################################################
# Karpenter 
################################################################################
resource "aws_iam_policy" "CustomEc2KarpenterPolicy" {
  count    = var.deploy_application_on_fargate ? 0 : 1
  name        = "EC2Policy-${var.aws_eks_cluster}"
  description = "Allows EC2 actions"
  policy      = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ec2:DescribeAvailabilityZones",
          "ec2:RunInstances",
          "ec2:TerminateInstances",
          "ec2:DescribeInstances",
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeSubnets",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeImages",
          "ec2:DescribeKeyPairs",
          "ec2:ImportKeyPair",
          "ec2:DescribeLaunchTemplates",
          "ec2:CreateTags"
        ],
        "Resource": "*"
      }
    ]
  })
}
data "aws_eks_cluster" "this" {
  count    = var.deploy_application_on_fargate ? 0 : 1
  name = var.aws_eks_cluster
}


# Creates Karpenter native node termination handler resources and IAM instance profile 
module "karpenter" {
  count    = var.deploy_application_on_fargate ? 0 : 1
  source = "./modules/karpenter"

  cluster_name           = var.aws_eks_cluster
  enable_irsa            = true
  irsa_oidc_provider_arn = data.terraform_remote_state.cluster.outputs.oidc_provider_arn

  # Used to attach additional IAM policies to the Karpenter node IAM role
  node_iam_role_additional_policies = {
    AmazonSSMManagedInstanceCore = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  }


  
}

resource "helm_release" "karpenter" {
  count    = var.deploy_application_on_fargate ? 0 : 1
  namespace        = "karpenter"
  create_namespace = true

  name                = "karpenter"
  repository          = "oci://public.ecr.aws/karpenter"
  chart               = "karpenter"
  version             = "0.36.2"

  values = [
    <<-EOT
    settings:
      clusterName: ${var.aws_eks_cluster}
      clusterEndpoint: ${data.terraform_remote_state.cluster.outputs.cluster_endpoint}              
      interruptionQueue: ${module.karpenter[0].queue_name}
      featureGates:
        spotToSpotConsolidation : true
    serviceAccount:
      annotations:
        eks.amazonaws.com/role-arn: ${module.karpenter[0].iam_role_arn}
    replicas: 1
    EOT
  ]
}


# data "kubectl_path_documents" "provisioner_manifests" {
#   pattern = "./karpenter-provisioner-manifests/${var.provisioner}/*.yaml"
#   vars = {
#     cluster_name = var.aws_eks_cluster
#     ROLE = module.karpenter.node_iam_role_name

#   }
# }
# resource "kubectl_manifest" "provisioners" {
#   for_each  = data.kubectl_path_documents.provisioner_manifests.manifests
#   yaml_body = each.value
# }
resource "kubectl_manifest" "karpenter_nodepool" {
  count    = var.deploy_application_on_fargate ? 0 : 1
  yaml_body = <<-YAML
apiVersion: karpenter.sh/v1beta1
kind: NodePool
metadata:
  name: k8s-karpenter-nodepool
spec:
  template:
    metadata:
      labels:
        intent: k8s-karpenter-nodepool
    spec:
      requirements:
        - key: karpenter.sh/capacity-type
          operator: In
          values: ["on-demand"]
        - key: karpenter.k8s.aws/instance-category
          operator: In
          values: ["t","c","m","r"]
        - key: karpenter.k8s.aws/instance-size
          operator: In
          values: ["medium","large","xlarge"]
      nodeClassRef:
        name: k8s-karpenter-nodepool
  limits:
    cpu: 1000
  disruption:
    consolidationPolicy: WhenUnderutilized
    expireAfter: 720h
  YAML
}


resource "kubectl_manifest" "karpenter_ec2nodeclass" {
  count    = var.deploy_application_on_fargate ? 0 : 1
  yaml_body = <<-YAML
apiVersion: karpenter.k8s.aws/v1beta1
kind: EC2NodeClass
metadata:
  name: k8s-karpenter-nodepool
spec:
  amiFamily: AL2023
  blockDeviceMappings:
  - deviceName: /dev/xvda
    ebs:
      encrypted: true
      volumeSize: 30Gi
      volumeType: gp3
  role: "${module.karpenter[0].node_iam_role_name}" # replace with your cluster name
  subnetSelectorTerms:
    - tags:
        karpenter.sh/discovery: "${var.aws_eks_cluster}" # replace with your cluster name
  securityGroupSelectorTerms:
    - tags:
        karpenter.sh/discovery/${var.aws_eks_cluster}-node: "${var.aws_eks_cluster}" # replace with your cluster name
  tags:
    karpenter.sh/discovery: ${var.aws_eks_cluster}
    Name: "k8s-karpenter-nodepool"
  YAML
}