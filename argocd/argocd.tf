
resource "kubernetes_namespace" "argocd" {

  metadata {
    labels = {
      "app.kubernetes.io/name" : var.namespace_argocd
    }
    name = var.namespace_argocd
  }
}

resource "time_sleep" "wait_60_seconds" {

  depends_on = [
    kubernetes_namespace.argocd,
  ]

  create_duration = "60s"
}

resource "helm_release" "argocd_helm" {


  name       = var.argocd_service_name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = var.argocd_version

  depends_on = [
    kubernetes_namespace.argocd
  ]

  namespace = kubernetes_namespace.argocd.metadata[0].name

  # set {
  #   name  = "nodeSelector"
  #   value = jsonencode({ intent = var.karpenter_staging_provisioner_name })
  # }

}




resource "kubernetes_ingress_v1" "argocd-ingress" {
  depends_on = [
    helm_release.argocd_helm
  ]
  wait_for_load_balancer = true
  metadata {
    namespace = var.namespace_argocd
    name      = "argocd-${var.env}"

    annotations = {
      "alb.ingress.kubernetes.io/certificate-arn"          = var.acm_certificate
      "alb.ingress.kubernetes.io/group.name"               = "${var.eks_cluster_name}"
      "alb.ingress.kubernetes.io/healthcheck-port"         = "traffic-port"
      "alb.ingress.kubernetes.io/listen-ports"             = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
      "alb.ingress.kubernetes.io/load-balancer-attributes" = "routing.http2.enabled=true"
      "alb.ingress.kubernetes.io/scheme"                   = "internet-facing"
      "alb.ingress.kubernetes.io/ssl-redirect"             = "443"
      "alb.ingress.kubernetes.io/success-codes"            = "200,302,301,404"
      "alb.ingress.kubernetes.io/target-type"              = "ip"
      "kubernetes.io/ingress.class"                        = var.alb_ingress_class
      "alb.ingress.kubernetes.io/security-groups"          = "${aws_security_group.ingress.id},${data.terraform_remote_state.cluster.outputs.cluster_primary_security_group_id}"

    }
  }
  spec {
    ingress_class_name = var.alb_ingress_class
    rule {
      host = var.argocd_host_name #"argocd.cultusorbitjobs.com"
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "${var.argocd_service_name}-server"
              port {
                number = 80
              }
            }
          }
        }
      }
    }
  }
}


resource "null_resource" "kubectl_patch" {
  depends_on = [
    kubernetes_ingress_v1.argocd-ingress
  ]
  provisioner "local-exec" {
    command = <<-EOT
      aws eks --region ${var.aws_region} update-kubeconfig --name ${var.eks_cluster_name}  && kubectl -n "argocd" patch deployment argocd-server --type json -p='[ { "op": "replace", "path":"/spec/template/spec/containers/0/command","value": ["argocd-server","--staticassets","/shared/app","--insecure"] }]'
    EOT
  }
}

resource "helm_release" "argocd_imageupdater_helm" {

  name       = var.argocd_image_updater_service_name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argocd-image-updater"
  version    = var.argocd_image_updater_version

  depends_on = [
    time_sleep.wait_60_seconds
  ]

  namespace = kubernetes_namespace.argocd.metadata[0].name

  values = [
    <<-EOT
    # nodeSelector: 
    #   intent : ${var.karpenter_staging_provisioner_name}
    config:
      registries: 
        - name: ECR
          api_url: "https://${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
          prefix: "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.aws_region}.amazonaws.com"
          ping: yes
          insecure: no
          credentials: ext:/scripts/auth1.sh
          credsexpire: 10h
    authScripts:
      enabled: true
      # -- Map of key-value pairs where the key consists of the name of the script and the value the contents
      scripts: 
        auth1.sh: |
          #!/bin/sh
          aws ecr --region ${var.aws_region}  get-authorization-token --output text --query 'authorizationData[].authorizationToken' | base64 -d

    serviceAccount:
      create: false
      name: service-account-${var.eks_cluster_name}
    EOT
  ]

}

resource "kubectl_manifest" "service_account_deployment" {

  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  name: service-account-${var.eks_cluster_name}
  namespace: ${var.namespace_argocd}
  annotations:
    eks.amazonaws.com/role-arn: ${data.terraform_remote_state.addon.outputs.sa_role_arn}
YAML

}

