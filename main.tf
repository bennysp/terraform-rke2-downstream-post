locals {
  cluster_name_effective = trimspace(var.cluster_name) != "" ? var.cluster_name : var.clustername

  kubeconfig_secret_parts = [for p in split("/", trim(var.vault_kubeconfig_secret_path, "/")) : p if p != ""]
  kubeconfig_mount        = length(local.kubeconfig_secret_parts) > 0 ? local.kubeconfig_secret_parts[0] : ""
  kubeconfig_name         = length(local.kubeconfig_secret_parts) > 1 ? join("/", slice(local.kubeconfig_secret_parts, 1, length(local.kubeconfig_secret_parts))) : ""

  autoscaler_secret_parts = [for p in split("/", trim(var.vault_cluster_autoscaler_path, "/")) : p if p != ""]
  autoscaler_mount        = length(local.autoscaler_secret_parts) > 0 ? local.autoscaler_secret_parts[0] : ""
  autoscaler_name         = length(local.autoscaler_secret_parts) > 1 ? join("/", slice(local.autoscaler_secret_parts, 1, length(local.autoscaler_secret_parts))) : ""

  kubeconfig_path_expanded = pathexpand(var.kubeconfig_location)
  kubeconfig_yaml          = try(file(local.kubeconfig_path_expanded), "")
  kubeconfig_decoded  = try(yamldecode(local.kubeconfig_yaml), {})
  k8s_host            = try(local.kubeconfig_decoded.clusters[0].cluster.server, "")
  k8s_ca              = try(base64decode(local.kubeconfig_decoded.clusters[0].cluster["certificate-authority-data"]), "")
  k8s_mgmt_host       = try(local.kubeconfig_decoded.clusters[0].cluster.server, "")
  k8s_mgmt_ca         = try(base64decode(local.kubeconfig_decoded.clusters[0].cluster["certificate-authority-data"]), "")
  k8s_token           = try(local.kubeconfig_decoded.users[0].user.token, "")
  k8s_mgmt_basehost   = length(split("/", local.k8s_mgmt_host)) > 2 ? split("/", local.k8s_mgmt_host)[2] : ""
  k8s_mgmt_token      = local.k8s_token

  k8s_host_effective  = local.k8s_host != "" ? local.k8s_host : "https://127.0.0.1"
  k8s_token_effective = local.k8s_token != "" ? local.k8s_token : "plan-placeholder-token"

  summary = {
    cluster_name                  = local.cluster_name_effective
    kubeconfig_location          = var.kubeconfig_location
    vault_kubeconfig_secret_path = var.vault_kubeconfig_secret_path
    vault_cluster_autoscaler_path = var.vault_cluster_autoscaler_path
  }
}
