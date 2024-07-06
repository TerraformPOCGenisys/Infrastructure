resource "kubernetes_namespace" "monitoring" {
  metadata {
    annotations = {
      name = var.monitoring_namespace
    }

    labels = {
      mylabel = var.monitoring_namespace
    }

    name = var.monitoring_namespace
  }
}
# resource "kubectl_manifest" "storageclass" {
#   depends_on = [  kubernetes_namespace.monitoring]

#   yaml_body = <<YAML
# apiVersion: storage.k8s.io/v1
# kind: StorageClass
# metadata:
#   name: storage-class-ebs-${var.eks_cluster_name}
# provisioner: ebs.csi.aws.com
# volumeBindingMode: WaitForFirstConsumer
# allowVolumeExpansion: true
# parameters:
#   type: gp3
#   encrypted: "true"
# YAML

# }

# resource "kubectl_manifest" "pvc" {
#   depends_on = [  kubectl_manifest.storageclass]

#   yaml_body = <<YAML
# apiVersion: v1
# kind: PersistentVolumeClaim
# metadata:
#   name: pvc-claim-ebs-${var.eks_cluster_name}
#   namespace : ${var.monitoring_namespace}
# spec:
#   accessModes:
#     - ReadWriteOnce
#   storageClassName: storage-class-ebs-${var.eks_cluster_name}
#   resources:
#     requests:
#       storage: 15Gi
# YAML

# }
resource "kubectl_manifest" "service_account_deployment" {

  yaml_body = <<YAML
apiVersion: v1
kind: ServiceAccount
metadata:
  name: service-account-${var.eks_cluster_name}
  namespace: ${var.monitoring_namespace}
  annotations:
    eks.amazonaws.com/role-arn: ${data.terraform_remote_state.addon.outputs.sa_role_arn}
YAML

}

###Grafana
resource "helm_release" "grafana" {
  # depends_on = [  module.lb_role , kubernetes_service_account.service-account]
  depends_on = [  kubernetes_namespace.monitoring]
  name       = "grafana"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = var.monitoring_namespace
  version    = var.grafana_version  


  set {
    name  = "persistence.enabled"
    value = "true"
  }

  set {
    name  = "persistence.accessModes[0]"
    value = "ReadWriteOnce"
  }

  set {
    name  = "persistence.size"
    value = "25Gi"
  }

  # set {
  #   name  = "persistence.existingClaim"
  #   value = "pvc-claim-ebs-${var.eks_cluster_name}"
  # }

  set {
    name  = "persistence.type"
    value = "pvc"
  }

  set {
    name  = "resources.limits.cpu"
    value = "700m"
  }

  set {
    name  = "resources.limits.memory"
    value = "700Mi"
  }

  set {
    name  = "resources.requests.cpu"
    value = "250m"
  }

  set {
    name  = "resources.requests.memory"
    value = "450Mi"
  }
}

####### loki  ######################
resource "helm_release" "loki" {
  #depends_on = [  module.lb_role , kubernetes_service_account.service-account]
  depends_on = [  helm_release.grafana]
  name       = "loki"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "loki-distributed"
  namespace  = var.monitoring_namespace
  version    = var.loki_version  

}
####### mimir  ######################
resource "helm_release" "mimir" {
  #depends_on = [  module.lb_role , kubernetes_service_account.service-account]
  depends_on = [  helm_release.loki]
  name       = "mimir"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "mimir-distributed"
  namespace  = var.monitoring_namespace
  version    = var.mimir_version  

}
####### mimir  ######################
resource "helm_release" "k8s-monitoring" {
  #depends_on = [  module.lb_role , kubernetes_service_account.service-account]
  depends_on = [  helm_release.mimir]
  name       = "k8s-monitoring"
  repository = "https://grafana.github.io/helm-charts"
  chart      = "k8s-monitoring"
  namespace  = var.monitoring_namespace
  version    = var.k8s_monitoring_version  

  set {
    name  = "cluster.name"
    value = "${var.eks_cluster_name}"
  }
  set {
    name  = "externalServices.prometheus.host"
    value = "http://mimir-nginx.monitoring.svc.cluster.local"
  }

  set {
    name  = "externalServices.prometheus.writeEndpoint"
    value = "/api/v1/push"
  }

  set {
    name  = "externalServices.prometheus.authMode"
    value = "none"
  }

  set {
    name  = "externalServices.loki.host"
    value = "http://loki-loki-distributed-gateway.monitoring.svc.cluster.local"
  }

  set {
    name  = "externalServices.loki.authMode"
    value = "none"
  }

  set {
    name  = "opencost.enabled"
    value = "false"
  }

  set {
    name  = "prometheus-operator-crds.enabled"
    value = "false"
  }

  set {
    name  = "metrics.enabled"
    value = "true"
  }

  set {
    name  = "metrics.node-exporter.enabled"
    value = "true"
  }
}

###ingress
resource "kubernetes_ingress_v1" "monitoring-ingress" {
  depends_on = [
      helm_release.grafana
  ]
  wait_for_load_balancer = true
  metadata {
    namespace = var.monitoring_namespace
    name      = "monitoring-${var.env}-ingress"

    annotations = {
      "alb.ingress.kubernetes.io/certificate-arn"         = var.acm_certificate 
      "alb.ingress.kubernetes.io/group.name"              = var.eks_cluster_name 
      "alb.ingress.kubernetes.io/healthcheck-port"        = "traffic-port"
      "alb.ingress.kubernetes.io/listen-ports"            = "[{\"HTTP\": 80}, {\"HTTPS\": 443}]"
      "alb.ingress.kubernetes.io/load-balancer-attributes"= "routing.http2.enabled=true"
      "alb.ingress.kubernetes.io/scheme"                  = "internet-facing"
      "alb.ingress.kubernetes.io/ssl-redirect"            = "443"
      "alb.ingress.kubernetes.io/success-codes"           = "200,302,301,404"
      "alb.ingress.kubernetes.io/target-type"             = "ip"
      "kubernetes.io/ingress.class"                       = var.alb_ingress_class

    }
  }
  spec {
    ingress_class_name = var.alb_ingress_class
    rule {
      host = var.grafana_host_name
      http {
        path {
          path      = "/"
          path_type = "Prefix"
          backend {
            service {
              name = "grafana"
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

