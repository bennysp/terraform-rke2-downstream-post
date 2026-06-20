resource "kubernetes_secret" "cluster_autoscaler_cloud_config" {
  count = var.enable_cluster_autoscaler ? 1 : 0

  metadata {
    name      = "cluster-autoscaler-cloud-config"
    namespace = "kube-system"
  }

  data = {
    "cloud-config" = <<EOF
url: https://${local.k8s_mgmt_basehost}
token: ${local.k8s_mgmt_token}
clusterName: ${local.cluster_name_effective}
clusterNamespace: "fleet-default"
EOF
  }

  type = "Opaque"
}

resource "kubernetes_config_map" "ca_cert" {
  count = var.enable_cluster_autoscaler ? 1 : 0

  metadata {
    name      = "ca-cert"
    namespace = "kube-system"
  }

  data = {
    "ca-certificates.crt" = local.k8s_mgmt_ca
  }
}
