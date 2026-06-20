resource "kubectl_manifest" "k8s_manifest_clusterissuer" {
  depends_on = [kubernetes_secret.vault_k8s_sa_token]

  yaml_body = templatefile("${path.module}/manifests/cluster-issuer.yaml.tmpl", {
    clustername         = local.cluster_name_effective
    vault_dns           = var.vault_dns
    vault_sec_ref       = var.k8s_sa_vault
    vault_role          = local.cluster_name_effective
    vault_k8s_auth_path = "kubernetes/downstream_k8s/${local.cluster_name_effective}"
  })
}
