provider "kubernetes" {
  host                   = local.k8s_host_effective
  cluster_ca_certificate = local.k8s_ca
  token                  = local.k8s_token_effective
}

provider "kubectl" {
  host                   = local.k8s_host_effective
  cluster_ca_certificate = local.k8s_ca
  token                  = local.k8s_token_effective
  load_config_file       = false
}

provider "helm" {
  kubernetes = {
    host                   = local.k8s_host_effective
    cluster_ca_certificate = local.k8s_ca
    token                  = local.k8s_token_effective
  }
}
