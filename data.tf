data "vault_kv_secret_v2" "kubeconfig" {
  mount = local.kubeconfig_mount
  name  = local.kubeconfig_name
}

data "vault_kv_secret_v2" "cluster_autoscaler_token" {
  mount = local.autoscaler_mount
  name  = local.autoscaler_name
}

data "rancher2_cluster_v2" "rancher_cluster" {
  name = local.cluster_name_effective
}
