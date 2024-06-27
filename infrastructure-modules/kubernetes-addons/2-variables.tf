variable "openid_provider_arn" {
  description = "The ARN of the OpenID Connect provider"
  type        = string
}

variable "eks_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "enable_cluster_autoscaler" {
  description = "Flag to enable cluster autoscaler"
  type        = bool
  default     = true
}

variable "cluster_autoscaler_helm_version" {
  description = "The Helm chart version for cluster-autoscaler"
  type        = string
  default     = "your_helm_version" # Set your default version here
}
